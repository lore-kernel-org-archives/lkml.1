Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbXJISPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbXJISPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbXJISPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:15:39 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:50360 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805AbXJISPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:15:38 -0400
Date: Tue, 9 Oct 2007 14:15:37 -0400
To: Bill Davidsen <davidsen@tmr.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [code] Unlimited partitions, a try
Message-ID: <20071009181537.GE4003@csclub.uwaterloo.ca>
References: <Pine.LNX.4.64.0710051347470.13406@fbirervta.pbzchgretzou.qr> <4706B6A8.2060800@zytor.com> <20071006002919.0b32c8b9@the-village.bc.nu> <4706C8BD.7080906@zytor.com> <4707E327.4020607@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4707E327.4020607@tmr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 03:33:59PM -0400, Bill Davidsen wrote:
> I'm not sure that configurations requiring more than 15 partitions are 
> properly described as "trivial." Which is not to disagree with your 
> point about required user tools, but most systems needing such tools 
> will be large and complex enough that a userspace solution will be 
> acceptable.

And there is LVM too, which seems better than partitions in many cases.

--
Len Sorensen
