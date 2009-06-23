Return-Path: <linux-kernel-owner+w=401wt.eu-S1759895AbZFWQrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895AbZFWQrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZFWQrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:47:43 -0400
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:40043 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754545AbZFWQrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:47:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ixd1+6/3jQ/2FqfeX9YIGOWWgEdUZdBQHzi3pVkzXBeXj2tt09vOma1iFviG4ifvqvGVxHQy/km/c1kz/nfpikCfasyBkLTyCoME0VLONrywgwQobzyY1gv4eqMCUcc+7vNK4LBc2PCbTUzGbgw7pSyln4uXNf5ec4kN13VnRw0=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: OeSuIg0VM1niJCvG3f_hcgvsOuXgPeQ69R_p18DBuiAxTjlORpl2sjrefJXwzU2T94Z8N7gq_z_DLasNb31.fY0UBl0tbLJ9IyllpzHJY.l5WT4fHzWImldyQnLpFiZKJPyeAYV_hS4dfvSt_WigG1cHjGdbNDkQcm6CFOlEKhEi6tkOirzQRBlTAtG_a5e_M1leyzwA3_l6k3LmpsUw6GjHIGj88VQzOnNiepzh9LTLXxbso6tFQIHmfhhoDZuOAzwKiou0WXEB7LcVs6wZgfdbXna4.VcC8oAPqKhq6tiWdSC6Kiz5
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
Date: Tue, 23 Jun 2009 09:47:44 -0700
User-Agent: KMail/1.9.10
Cc: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
       "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com> <20090623105445.6bec978c@lxorguk.ukuu.org.uk> <000901c9f413$70b2ece0$5218c6a0$%szyprowski@samsung.com>
In-Reply-To: <000901c9f413$70b2ece0$5218c6a0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906230947.44398.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Marek Szyprowski wrote:
> David: do you want to update a g_serial driver and disable the low latency
> mode, or should I post a patch that does it? Or do you have other plan to
> solve this issue? I tested the g_serial driver with low latency mode
> disabled and it works quite fine here on ARM S3C6410.

I'd like you to submit that.

- Dave

