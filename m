Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbXFDK41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbXFDK41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 06:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbXFDK4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 06:56:16 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:5213 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbXFDK4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 06:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G2H5irhRFupYg0ACV2YwMaRXjq4ifSKYRzwxMU9QpLdcuC/beiTZedXkK6UQRnIKeT7YDtElbPG0EbaONRCnVDgwvAvlOsCzo4EBx1FYD5bZpvWJZ7Ra2yr4tDZ6J9/JT/L5FJ12URMVAVcR8VizaH2oAqbq/CdriI8Dw/GgaDU=
Message-ID: <b6fcc0a0706040356x7cad92ecl51f4d1aec6a85624@mail.gmail.com>
Date: Mon, 4 Jun 2007 14:56:14 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: Biker <biker@villagepeople.it>
Subject: Re: WARNING: at mm/slab.c:777 __find_general_cachep() in 2.6.22-rc3
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200706041229.37779.biker@villagepeople.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706041229.37779.biker@villagepeople.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Biker <biker@villagepeople.it> wrote:
> WARNING: at mm/slab.c:777 __find_general_cachep()
>  [<c016e0c4>]  [<f943288c>]  [<f9112bfa>]  [<f90f8546>]  [<c0104c90>]
> [<c033702e>]  [<f90f15dd>]  [<f911de1d>]  [<f911e123>]  [<c01714d7>]
> [<f911ba7c>]  [<f94300c9>]  [<f943016f>]  [<f9430157>]  [<c017d0bb>]
> [<c0172741>]  [<c017d17c>]  [<c017d3fd>]  [<c01041c2>]

Please, enable CONFIG_DEBUG_BUGVERBOSE, or decipher addresses
into function calls yourself.
