Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbYBFN5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbYBFN5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 08:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYBFN5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 08:57:12 -0500
Received: from twin.jikos.cz ([213.151.79.26]:54050 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbYBFN5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:57:11 -0500
Date: Wed, 6 Feb 2008 14:56:01 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Theodore Tso <tytso@MIT.EDU>
cc: Felipe Balbi <felipebalbi@users.sourceforge.net>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>,
       "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: T61P sound issue
In-Reply-To: <20080206135306.GI27119@mit.edu>
Message-ID: <Pine.LNX.4.64.0802061455110.30873@twin.jikos.cz>
References: <31e679430801270549u49e1c549qf602b36b07aabc2b@mail.gmail.com>
 <20080204194038.d8851b8d.akpm@linux-foundation.org> <20080205113633.GI27738@hjernemadsen.org>
 <20080205102219.83fe459d.akpm@linux-foundation.org>
 <31e679430802051304l7c1d68d8r153c753a5b96087a@mail.gmail.com>
 <Pine.LNX.4.64.0802052207330.30873@twin.jikos.cz> <20080206022517.GB27119@mit.edu>
 <Pine.LNX.4.64.0802060909420.30873@twin.jikos.cz> <20080206135306.GI27119@mit.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Theodore Tso wrote:

> > I have also seen sound working flawlessly on another X61s. Maybe they 
> > changed some chipset revisions on the fly, or whatever.
> > What does lspci -v show for your soundcard please?
> Attached please find my lspci -v and dmidecode information.

Thanks. As I have already written elsewhere in this thread, the problem 
went away after I updated the BIOS to the latest version. So it was Lenovo 
who was to blame, and I was just unlucky enough to hit the series with 
broken BIOS.

Thanks,

-- 
Jiri Kosina
