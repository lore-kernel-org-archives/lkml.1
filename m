Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbYEMKYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbYEMKYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 06:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYEMKYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 06:24:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:55664 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYEMKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 06:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fupZ6+ENAnM/TLrF5i56d1WO30L4/DO3WANMMsy0upVCkV9EUEOXjduHsMRCLCnBG66vkHaDSgh9aFw2pM7xdxkstRC4K5g5h/kQ/ZiarNKyo5SXzo5RbMZLTuWOr6fX960sji1pq8OKXvO9fP5HTwD/1Z/MMViltFVAlAR52Pw=
Message-ID: <386072610805130323u1cad7b4fj512442ef1465a41f@mail.gmail.com>
Date: Tue, 13 May 2008 18:23:43 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] [8250 Serial Driver]: Added support for 8250-class UARTs in HV Sistemas H8606 board
Cc: linux-kernel@vger.kernel.org, "Javier Herrero" <jherrero@hvsistemas.es>
In-Reply-To: <20080513105031.2418dbbb@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210652069-16788-1-git-send-email-cooloney@kernel.org>
	 <1210652069-16788-2-git-send-email-cooloney@kernel.org>
	 <20080513105031.2418dbbb@core>
X-Google-Sender-Auth: ed4a5c194c3aaeff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 5:50 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 13 May 2008 12:14:28 +0800
>  Bryan Wu <cooloney@kernel.org> wrote:
>
>  > From: Javier Herrero <jherrero@hvsistemas.es>
>  >
>  > Added support for 8250-class UARTs in HV Sistemas H8606 board,
>  > modification in 8250.c driver for correct compilation with Blackfin
>  >
>  > Besides, I think that there is more people using 8250-class UARTs
>  > with a different hardware than the H8606 board. This code can be shared
>  > by them.
>  >
>  > Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
>  > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
>  > Signed-off-by: Bryan Wu <cooloney@kernel.org>
>
>  Acked-by: Alan Cox <alan@redhat.com>

Thanks, I will apply this patch to Blackfin git-tree

-Bryan
