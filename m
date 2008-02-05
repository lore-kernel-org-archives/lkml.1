Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbYBEKUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbYBEKUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbYBEKT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:19:58 -0500
Received: from styx.suse.cz ([82.119.242.94]:57341 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757283AbYBEKT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:19:57 -0500
Date: Tue, 5 Feb 2008 11:19:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Sterba <dsterba@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ben Martel <benm@symmetric.co.nz>,
       stephen@symmetric.co.nz
Subject: Re: [PATCH][v4] ipwireless: driver for 3G PC Card
In-Reply-To: <20080201153707.GA24859@ds.suse.cz>
Message-ID: <Pine.LNX.4.64.0802051114390.30955@jikos.suse.cz>
References: <20080201153707.GA24859@ds.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, David Sterba wrote:

> From: David Sterba <dsterba@suse.cz>
> ipwireless: driver for PC Card, 3G internet connection

Linus, as there is no PCMCIA maintainer and akpm apparently wants you to 
merge this directly [1] -- what is your position on this one please? As 
far as I can see all the major issues that were raised during review were 
fixed by David, so there shouldn't be any obstacles to merging it. It 
would be nice if this driver will make it for 2.6.25 merge window.

Thanks,

[1] http://lkml.org/lkml/2007/12/17/302

-- 
Jiri Kosina
