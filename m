Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbXJ2NIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbXJ2NIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbXJ2NHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:07:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:51406 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109AbXJ2NHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:07:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Sk0ddyUYh5UV9y0s+z3KvLh2cN0RgfdZSu2LVDZ/eBc6S5G30K1s2Vm4GYBjosc/STwiKjPWvtqGPfOft3hN1p7HhwiLBNIcfLNLnHBVy055MwG3Qz8b7UGLB2a2v2MM4R1KWZb2xM1sGJNllNVPk5mXzssqdS2mgzz6/DAyk8I=
Message-ID: <d120d5000710290607x66832f96lad21d37fff987b09@mail.gmail.com>
Date: Mon, 29 Oct 2007 09:07:46 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "=?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?=" <oliver.pntr@gmail.com>
Subject: Re: [REGRESSION 2.6.22.Y] KEYBOARD && CAPSLOCK && RANDOM UPPER and LOWERCASE CHARs
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6101e8c40710281850s2d9ca5ads6859ed692c21bc51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40710281850s2d9ca5ads6859ed692c21bc51@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olivér,

On 10/28/07, Olivér Pintér <oliver.pntr@gmail.com> wrote:
> Hi Dmitry!
>
> I have one very nice regression ... under 2.6.22 kernel, im VT mode,
> when I turn on the caps lock and I typing for Q - M, then become this
> string: qwERTZUiOPõúAsdfgHjkléáûíyxcvbnM
>
> i tested under 2.6.22.9 tainted, 2.6.22.9 not tainted, 2.6.22.10
> tainted and 2.6.22.10 not tainted. Under FreeBSD is all ok, and under
> X is ok. All kernell tested under debian 3.1 Sarge and 4.0 Etch.
>

I presume 2.6.21 works for you? Could you tell me what keymap you are loading?

-- 
Dmitry
