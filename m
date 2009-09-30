Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbZI3JhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbZI3JhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 05:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZI3Jg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 05:36:59 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:57150 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZI3Jg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 05:36:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XvTF3HqPrqioX66TStMI58eDVSdnwREkBncP2A5K1acskaYTmg56UrzSjhIYkgo/Sr
         vyaJE4q6P7O0LCvryM8AOQ2flqhUUdNmewnMJS4i6AMgUEi4kuoKAKoadwh0oRBw0FI2
         SXy1UQDfbXpnuCAk+mEE4aOyFvM5lcQPreC1M=
MIME-Version: 1.0
In-Reply-To: <1253630313-20225-1-git-send-email-linus.walleij@stericsson.com>
References: <1253630313-20225-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 30 Sep 2009 11:37:01 +0200
Message-ID: <63386a3d0909300237i5d2e8fe0k80672e429a4f1917@mail.gmail.com>
Subject: Re: [PATCH 1/2] Add COH 901 318 DMA block driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/22 Linus Walleij <linus.walleij@stericsson.com>:

> This patch adds support for the ST-Ericsson COH 901 318 DMA block,
> found in the U300 series platforms. It registers a DMA slave for
> device I/O and also a memcpy slave for memcpy.

Are there no further comments on this DMA driver or are the subsystem
maintainers simply busy right now?

Linus Walleij
