Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZI3Pc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZI3Pc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZI3Pc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:32:58 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:34179 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbZI3Pc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=MFDyF+fsUzH0FvDDu0VxVDqtJypRLw0PK/kCKZB4tbjgL9ZpJ3dBCYwAH+OPqjqsQW
         4xIsA0K8qnxCxVTORFMEfuBwe/P3EJaYBwU9vnch4/M5AGUeQSMr61WXd4ekFLuYvVZP
         ecEj5uDfK87ORpxIWhUv7TLNrklfPk2eJxHdQ=
MIME-Version: 1.0
In-Reply-To: <63386a3d0909300237i5d2e8fe0k80672e429a4f1917@mail.gmail.com>
References: <1253630313-20225-1-git-send-email-linus.walleij@stericsson.com>
	 <63386a3d0909300237i5d2e8fe0k80672e429a4f1917@mail.gmail.com>
Date: Wed, 30 Sep 2009 08:33:01 -0700
X-Google-Sender-Auth: d5d607e708b73192
Message-ID: <e9c3a7c20909300833n1c1262b2q803b0b8b6f1c5bdb@mail.gmail.com>
Subject: Re: [PATCH 1/2] Add COH 901 318 DMA block driver
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 2:37 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2009/9/22 Linus Walleij <linus.walleij@stericsson.com>:
>
>> This patch adds support for the ST-Ericsson COH 901 318 DMA block,
>> found in the U300 series platforms. It registers a DMA slave for
>> device I/O and also a memcpy slave for memcpy.
>
> Are there no further comments on this DMA driver or are the subsystem
> maintainers simply busy right now?
>

With the merge window and Plumber's I have been distracted.  I'll take
a look and send feedback in the next day or so.

Thanks,
Dan
