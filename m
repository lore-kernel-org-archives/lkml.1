Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbZFBPqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbZFBPqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZFBPqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:46:15 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:42820 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbZFBPqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:46:15 -0400
Date: Tue, 2 Jun 2009 17:46:16 +0200
From: Andreas Mohr <andi@lisas.de>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mISDN GIT: hfcpci cleanup failure on IRQ weirdness
Message-ID: <20090602154616.GB10941@rhlx01.hs-esslingen.de>
References: <20090602130649.GA14794@rhlx01.hs-esslingen.de> <200906021729.58677.isdn@linux-pingi.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906021729.58677.isdn@linux-pingi.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 02, 2009 at 05:29:58PM +0200, Karsten Keil wrote:
> Hmm, I think shared as comment in the IRQ function should be
> enough -  but  I do not complain to a longer comment.

OK, whatever. It has better verbosity, but maybe too much.

> easier:
> 			if (cnt == 1)
> 				break;
> 			else {
> 
> 
> I will send this patch together with some other ISDN fixes again soon.

Thanks!

Andreas Mohr
