Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbZIGSRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbZIGSRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 14:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZIGSRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 14:17:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:23161 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZIGSRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 14:17:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LExGoAJJjNKjVULDoGoYkxd40mbRi5gtPYFNpEyZqs5SRdXmWlWoKTlOS33bYe2reI
         K0xIjVB+AYyZjoLPEm4srJzrnkCAqT+UXisCm8OkF9DJqw+o/N8dMDRL1TTFCqSj+AJu
         PHmWdR/JC9e6OtcwDnWcvk7YGyPQV7GQHVCGw=
MIME-Version: 1.0
In-Reply-To: <1252317170-9782-1-git-send-email-albin.tonnerre@free-electrons.com>
References: <cd73a99e0909062322j683952e6m803dd6b703bf758d@mail.gmail.com>
	 <1252317170-9782-1-git-send-email-albin.tonnerre@free-electrons.com>
Date: Mon, 7 Sep 2009 20:17:35 +0200
Message-ID: <cd73a99e0909071117s720f933sd5f778235170688d@mail.gmail.com>
Subject: Re: [PATCH v2] Add poll_get_char and poll_put_char uart_ops to 
	atmel_serial.
From: Andrew Victor <avictor.za@gmail.com>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       nicolas.ferre@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Albin,

> This patch allows using KGDB over the console with the atmel_serial
> driver.
>
> Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>

Acked-by: Andrew Victor <linux@maxim.org.za>
