Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbYHHQ4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbYHHQ4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYHHQ4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:56:24 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:15810 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbYHHQ4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:56:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=pQhNx0mGfwNkvtB9ZTixxoXjZNlRcihBcOkxfbMdEwehfMHxMYzFCeMDzV5juTOQk4
         qvHi/P9cijUKYyQNR7HvuKRaO60uxFByyivX5jCF0esAoFYh96etGWKOw+obrQpHlIev
         3sjhseyPoi0awGTLnFvp9rLdfVDOcD82VotAQ=
Message-ID: <9ea470500808080956m23f59966nb9b1955e174d157d@mail.gmail.com>
Date: Fri, 8 Aug 2008 18:56:22 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [8/17] ide-cd: use bcd2bin/bin2bcd
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Brownell" <david-b@pacbell.net>
In-Reply-To: <20080808163446.GO14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080808163446.GO14495@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2008 at 6:34 PM, Adrian Bunk <bunk@kernel.org> wrote:
> This patch changes ide-cd to use the new bcd2bin/bin2bcd functions
> instead of the obsolete BCD2BIN/BIN2BCD macros.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Borislav Petkov <petkovbb@gmail.com>

[.. ]

-- 
Regards/Gruss,
Boris.
