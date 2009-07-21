Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbZGUUgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbZGUUgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbZGUUgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:36:08 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:35562 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbZGUUgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=S8kiye5akmc2ItvPQ3oe0U9CZAZ0Kn7f6IV5GOnYlxCuXG1cIaXGVmeRk4T4RWGeZD
         yhyB2edU8J5wfoDzoFlWs3tSD1kOB2TxF+AqUg1tPGkgqc8+e4UB+y1G2LTa2rw44Az0
         RUyXDUK1DaAzcTQin8/WXkBMkdveicePpYX8o=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/2] MMC Agressive clocking framework v5
Date: Tue, 21 Jul 2009 22:35:46 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-1-amd64; KDE/4.2.4; x86_64; ; )
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pierre Ossman <pierre@ossman.eu>
References: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com> <63386a3d0907211328v3c060012r3acc2d5f88e4d9eb@mail.gmail.com>
In-Reply-To: <63386a3d0907211328v3c060012r3acc2d5f88e4d9eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907212235.47006.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Út 21. července 2009 22:28:25 Linus Walleij napsal(a):
> Then the ChangeLog I missed yesterday due to sitting up too
> late:
>
> ChangeLog v4->v5:
>
> * Make mmc_set_data_timeout() in core.c work even if ios.clock is
>   set to zero by the clock gating code.
>
> * Give the host-centric functions the mmc_host_clk* prefix instead
>   so it is clear that it's host functionality that is being
>   called.
>
> * Mailing this to Andrew Morton and LKML since the previous MMC
>   maintainer stepped down.
Pierre gave up on mmc subsystem maintainance ?
>
> Linus Walleij
>
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php

