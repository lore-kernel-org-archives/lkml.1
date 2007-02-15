Return-Path: <linux-kernel-owner+w=401wt.eu-S1161594AbXBOWoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161594AbXBOWoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161593AbXBOWoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:44:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:19840 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161597AbXBOWoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:44:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lpIJaZKY6Ka95g3tqSWTH5s+1H0GsmNXDciFSUK+0rB+PBP3IU5GXJMG5nttJXOYqMzVpvSAD1eLTw/SZeq9uRJ2xLJMZEif1ODg+RaW/56tNWT8ozSnJBNoXZ8BFUZ8MCDoznaDphnEL42HeuvvXSBS6un3vncpC5AnOEi3QqM=
Message-ID: <e13597370702151444u1b207656x3d37f8d183adf645@mail.gmail.com>
Date: Fri, 16 Feb 2007 01:44:10 +0300
From: "Eugene Ilkov" <e.ilkov@gmail.com>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: 2.6.20 mmc: problem with highspeed SD card
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D4939B.1080200@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e13597370702131746q6a5d8e79i2341f5eb9c59bf6e@mail.gmail.com>
	 <45D3F41C.3020600@drzeus.cx>
	 <e13597370702150417o3888b71dtcc42e38156b46918@mail.gmail.com>
	 <45D48FB6.80703@drzeus.cx> <45D4939B.1080200@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> Pierre Ossman wrote:
> > Eugene Ilkov wrote:
> >> PXAMCI: irq 00000004 stat 00002140
> >
> > Hang on. PXAMCI is a MMC controller, right?

yes, pxa2xx-mci driver

>
> Hmm... depending on where you look, you get different timing schematics. The
> MMCA 4.2 specification (which should be authoritative) does indicate that things
> are incompatible though.
>
> I'll put together a patch that you can try out.

ok
