Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbXLLSkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbXLLSkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758434AbXLLSjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:39:43 -0500
Received: from nz-out-0506.google.com ([64.233.162.238]:56960 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758393AbXLLSjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:39:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QNdXZUhXVoIKbGE0tleKaSGAPm5IwjgjesFUcKV2waXx79+Uy2CkjnEZpovQ9F5yu//GKlTnhK3HIYhDj9R7RxAi0gR51EJanASiJRz/Uu5HGEkIjx0AZaic4GowY7oXPcO0UzONJQthkmkfNyypDVPPwocv5QPBogmTjuLvpo8=
Message-ID: <ed10ee420712121039j79af0eq7b5a994215044199@mail.gmail.com>
Date: Wed, 12 Dec 2007 10:39:40 -0800
From: "SL Baur" <steve@xemacs.org>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: [RFT] Port 0x80 I/O speed
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz,
       andi@firstfloor.org, rol@as2917.net, "Krzysztof Halasa" <khc@pm.waw.pl>,
       david@davidnewall.com, hpa@zytor.com, john@stoffel.org,
       linux-os@analogic.com
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <475F1DC6.5090403@keyaccess.nl>
X-Google-Sender-Auth: 6a48fc4a58a2e9f8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/07, Rene Herman <rene.herman@gmail.com> wrote:
> Good day.
>
> Would some people on x86 (both 32 and 64) be kind enough to compile and run
> the attached program? This is about testing how long I/O port access to port
> 0x80 takes. It measures in CPU cycles so CPU speed is crucial in reporting.

model name      : Intel(R) Pentium(R) 4 CPU 3.20GHz
cpu MHz         : 3201.345

cycles: out 3026, in 2204
cycles: out 3031, in 2182
cycles: out 3019, in 2196
cycles: out 3030, in 2201
cycles: out 3013, in 2186

-sb
