Return-Path: <linux-kernel-owner+w=401wt.eu-S932684AbXCOW0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbXCOW0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933934AbXCOW0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:26:46 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:15944 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764AbXCOW0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PZdF1eb4Aj42anBX/pPQEOn/5g3/Rgpu2Gdr0ex4pwKc52rji2Tz1PkkabmpxM2W/Nx0RHOG0QGTzKLIuFXMmxoBz0gOm/R7zQ0DzxXNCzJofBhKcu2U8kjkjpR5xezFqTInE8+U+4REQDIq5mCuAnK/UmX52vn2rByQApULzpA=
Message-ID: <8bd0f97a0703151526h7965dd26w362153c9c1a3f62d@mail.gmail.com>
Date: Thu, 15 Mar 2007 18:26:39 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>
Subject: Re: [PATCH] blackfin: balance parenthesis in macros
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
In-Reply-To: <200703152312.21981.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703152312.21981.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/07, Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
>         This patch (against 2.6.21-rc3-mm1) balances parenthesis in blackfin
> header files.
>
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

thanks, added to our repo
-mike
