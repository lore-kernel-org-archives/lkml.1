Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbXJVXA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbXJVXA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 19:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbXJVXAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 19:00:20 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:27587 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbXJVXAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 19:00:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pplMcv1R0f1f4jKihV+OXxLkb89tA9EXPsJ62SBMu4Q7zACVHert9+IdsLQtTTZR7G6/mA2pgLonkPP5MSyA4crLpC2uueQyZ2FAIop3jR7aD8sjRyI2fPBjM0CbomsncSUen/7tqquPzejzTSbvRxIPqv0fWEvs6ICaX5dxpOs=
Message-ID: <2c0942db0710221600j24f76f68lefe562cc8bc2d067@mail.gmail.com>
Date: Mon, 22 Oct 2007 16:00:16 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] return hidden bug
Cc: "Roel Kluin" <12o3l@tiscali.nl>, "Rik van Riel" <riel@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <471D23AA.2000803@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471BF741.2020501@tiscali.nl>
	 <20071021214209.1a7567d7@bree.surriel.com>
	 <2c0942db0710220942he5e9199i2e327df3c5676a6a@mail.gmail.com>
	 <471CE453.5050208@tiscali.nl>
	 <2c0942db0710221112g7c7d99caj7feb0c2ac5de17e7@mail.gmail.com>
	 <471CF150.9090707@tiscali.nl> <471D23AA.2000803@keyaccess.nl>
X-Google-Sender-Auth: 3a2bf1150f99e939
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/07, Rene Herman <rene.herman@keyaccess.nl> wrote:
> Hugely trust inspiring isn't it -- the amount of eyes and comments you'll
> get even on trivial patches like this? This development model is working!

Go easy with the snarkiness, hmm? It's the trivial ones that seem to
be the most dangerous. The larger ones actually get *tested*
sometimes.

> Now if only we'd sometimes get some for non trivial patches as well...

That's certainly true regardless, but for myself, I'd rather throw
some reviews out for the small ones since I have adequate time and
knowledge for them. The larger ones require domain specific knowledge
I lack, and time I don't have.

~r.
