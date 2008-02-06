Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbYBFIMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbYBFIMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 03:12:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbYBFILw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 03:11:52 -0500
Received: from twin.jikos.cz ([213.151.79.26]:39793 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876AbYBFILv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 03:11:51 -0500
Date: Wed, 6 Feb 2008 09:11:27 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Theodore Tso <tytso@MIT.EDU>
cc: Felipe Balbi <felipebalbi@users.sourceforge.net>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>,
       "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: T61P sound issue
In-Reply-To: <20080206022517.GB27119@mit.edu>
Message-ID: <Pine.LNX.4.64.0802060909420.30873@twin.jikos.cz>
References: <31e679430801270549u49e1c549qf602b36b07aabc2b@mail.gmail.com>
 <20080204194038.d8851b8d.akpm@linux-foundation.org> <20080205113633.GI27738@hjernemadsen.org>
 <20080205102219.83fe459d.akpm@linux-foundation.org>
 <31e679430802051304l7c1d68d8r153c753a5b96087a@mail.gmail.com>
 <Pine.LNX.4.64.0802052207330.30873@twin.jikos.cz> <20080206022517.GB27119@mit.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Theodore Tso wrote:

> Hmm.. sound works just fine for me on my X61s (model #7668-CTO) running 
> 2.6.24.

I have also seen sound working flawlessly on another X61s. Maybe they 
changed some chipset revisions on the fly, or whatever.

What does lspci -v show for your soundcard please?

> I do have this private patch applied --- maybe it makes a difference
> for you?  I don't think it should make a difference, but....

I will give it a try, thanks.

-- 
Jiri Kosina
