Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbZE2MGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbZE2MGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758343AbZE2MGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:06:31 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:36277 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231AbZE2MGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:06:31 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [VIA Support] was: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Fri, 29 May 2009 07:06:27 -0500
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <20090524064905.GH20452@prithivi.gnumonks.org> <200905270718.11093.lkml@morethan.org>
In-Reply-To: <200905270718.11093.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905290706.30627.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed May 27 2009, Michael S. Zick wrote:
> On Sun May 24 2009, Harald Welte wrote:
> > 
> > Once I understand it in full detail, I can talk to the right people inside
> > CentaurLabs (VIA's CPU division).  
> > 

The trial build of yesterday's repository head is now posted, details at:
http://forum.netbookuser.com/viewtopic.php?pid=7002#p7002

I don't consider the C7-M/CX700 whack-a-bug project finished. . .
But I haven't broken my C7-M/CN896 yet either.  ;)

Mike

