Return-Path: <linux-kernel-owner+w=401wt.eu-S935104AbYBGX1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935104AbYBGX1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760192AbYBGX1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:27:12 -0500
Received: from styx.suse.cz ([82.119.242.94]:41785 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758223AbYBGX1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:27:10 -0500
Date: Fri, 8 Feb 2008 00:27:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
       Ben Martel <benm@symmetric.co.nz>, stephen@symmetric.co.nz,
       David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH][v5] ipwireless: driver for 3G PC Card
In-Reply-To: <20080207095712.GA32360@ds.suse.cz>
Message-ID: <Pine.LNX.4.64.0802080024450.30955@jikos.suse.cz>
References: <20080201153707.GA24859@ds.suse.cz> <Pine.LNX.4.64.0802051114390.30955@jikos.suse.cz>
 <1202255212.15090.180.camel@violet> <alpine.LFD.1.00.0802051600330.2967@woody.linux-foundation.org>
 <20080207095712.GA32360@ds.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, David Sterba wrote:

> updated to v5.
> 
> Changes:
> - minor cleanups
> - removed modparam for static tty major assignment
> Please apply.
> David Sterba

Linus -- as there are no other pending objections to the code so far, and 
I think we agreed that this has nothing to do neither with wireless tree, 
nor with networking drivers in general (it is basically a PCMCIA serial 
driver, and thus there is no relevant maintainer alive), would you please 
consider merging it for 2.6.25?

David, thanks a lot for taking care of another respin.

Thanks,

-- 
Jiri Kosina
