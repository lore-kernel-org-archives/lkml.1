Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbYEVQMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbYEVQMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYEVQMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:12:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35282
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754259AbYEVQMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:12:34 -0400
Date: Thu, 22 May 2008 09:12:29 -0700 (PDT)
Message-Id: <20080522.091229.229699590.davem@davemloft.net>
To: schwab@suse.de
Cc: torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk, paulus@samba.org,
       tiwai@suse.de, linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-*
From: David Miller <davem@davemloft.net>
In-Reply-To: <je1w3uu5dc.fsf@sykes.suse.de>
References: <alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org>
	<20080521.182335.28689253.davem@davemloft.net>
	<je1w3uu5dc.fsf@sykes.suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Schwab <schwab@suse.de>
Date: Thu, 22 May 2008 10:09:51 +0200

> David Miller <davem@davemloft.net> writes:
> 
> > If you want to figure out where something is implemented for a given
> > target, you have to walk through the tree like a monkey in some
> > prioritized list of directories to find the source file or header file
> > that glibc ends up using.
> 
> The dependencies file contains the exact list of used files.

That doesn't make it any more intuitive.
