Return-Path: <linux-kernel-owner+w=401wt.eu-S1758394AbXEUFA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394AbXEUFA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 01:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbXEUFAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 01:00:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:17698 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573AbXEUFAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 01:00:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KY/rI7AgSrIVd3tx8yJrd7/jJi5oCCxAcWs/obkW3yp01MQ6yyWx5i5aJscHSfetRGTMEq4xdxlo/Y/XQT6uhjcmJmZUnvT5zixjUCfhJTSaeS2V2ixlIJTzt5n7BGsTnorsuHdTIDZ7vtefOqprCgvtitpIY9fdJ7no6GwV1Us=
Message-ID: <a8e1da0705202200u5976d14do7ec1469941bb2967@mail.gmail.com>
Date: Mon, 21 May 2007 05:00:48 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.22-rc1-mm1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <465124EA.1020801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com>
	 <a8e1da0705180154v37e8ec5fs2cc4de9417cd44d2@mail.gmail.com>
	 <a8e1da0705180307m60a91996r91c8bfcd1c863a94@mail.gmail.com>
	 <464DDA40.6010101@zytor.com>
	 <a8e1da0705201753i1527138ape2163817c6c0d3b5@mail.gmail.com>
	 <465124EA.1020801@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried the vga option , and the selection menu appeared, then I
select 0(80x25) and nothing happened.

2007/5/21, H. Peter Anvin <hpa@zytor.com>:
> young dave wrote:
> > Hi,
> > My cpu is Intel(R) Pentium(R) D CPU 2.80GHz, below are the lspci
> > output and kernel
>
> Could you please try booting with "vga=ask", and see if you get the
> video mode selection menu?
>
>         -hpa
>
