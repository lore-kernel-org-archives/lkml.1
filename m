Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZFXHkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZFXHkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZFXHkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:40:49 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:33776 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbZFXHks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ex94yrtCcLBzHttVM6z2tVNZdpQBii3VwHjJFn2fxxGfd7gfmj5DYPeptQ0qtoFWil
         GRxrwnld9EY9AK5GwkiSBRQfqj1ah1p8iKg2/EXuPQ/avFpAjRnqP+5dZsClzgTyZOOc
         oXsKe9LFAKxOAokwlQejn7sMY63F2a/v7c2t4=
MIME-Version: 1.0
In-Reply-To: <20090624172735.9b500674.sfr@canb.auug.org.au>
References: <20090624164617.b7c49974.sfr@canb.auug.org.au>
	 <20090624172735.9b500674.sfr@canb.auug.org.au>
Date: Wed, 24 Jun 2009 10:40:48 +0300
X-Google-Sender-Auth: 86ba7f5a0c4b1dbd
Message-ID: <84144f020906240040ycf40bd6q20af82907315adc2@mail.gmail.com>
Subject: Re: Main things left in linux-next
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>, Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

[ I'm trimming the cc list a bit. ]

2009/6/24 Stephen Rothwell <sfr@canb.auug.org.au>:
> The main obvious things left are:
>
> SLQB from the slab tree

This didn't make it to 2.6.31. Do you want me to drop it until -rc1 is out?

                                        Pekka
