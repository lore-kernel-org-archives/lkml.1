Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306Ab0ANKHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab0ANKHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 05:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990Ab0ANKHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 05:07:12 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62491 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0ANKHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 05:07:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p+PmtiOgJTRkYA7tmop/HPFOiSuSfBfOcP5DvrK54Hoanu2G1C4RdHaDOtXs3gItBo
         K2NJiTljPVVfc7wib8l5Cw1HtywhvoFfQth7uBf5NDZzo6B8i7qQL9adQ424X/X2e550
         V5M/vqCl1ksCtGoV8PaT3yPFCOgBS2McZJ7oA=
MIME-Version: 1.0
In-Reply-To: <20100113115712.GA7398@faui49.informatik.uni-erlangen.de>
References: <20100113115712.GA7398@faui49.informatik.uni-erlangen.de>
Date: Thu, 14 Jan 2010 11:07:08 +0100
Message-ID: <63386a3d1001140207p5e2546fq2d8201ee87edfd46@mail.gmail.com>
Subject: Re: [PATCH] typo in kernel source (DEBUGFS)
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
       sameo@linux.intel.com, Reinhard.Tartler@informatik.uni-erlangen.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/13 Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>:

>        While working on this we detected a spelling error in
> drivers/mfd/ab3100-otp.c which can be corrected using the attached
> patch.

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Linus Walleij
