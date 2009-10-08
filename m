Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbZJHMPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbZJHMPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 08:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbZJHMPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 08:15:37 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:50642 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbZJHMPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 08:15:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PBHofIBNhOy77AZP1ke3hkfSndrySgHYkp7dUvbIZY+pBI0YPSNzpczvB0Ya2m0c0i
         n7ZtGfHeOM0TrYb5MEtDg01P6m5uqeKRP8V/54o7eBk6pvL678txYpTh4VYYj5fFeuK5
         J3kLgZeJbNqGo+iMqH5J/JUB85XoIRjkjpeP0=
MIME-Version: 1.0
In-Reply-To: <e9c3a7c20909300833n1c1262b2q803b0b8b6f1c5bdb@mail.gmail.com>
References: <1253630313-20225-1-git-send-email-linus.walleij@stericsson.com>
	 <63386a3d0909300237i5d2e8fe0k80672e429a4f1917@mail.gmail.com>
	 <e9c3a7c20909300833n1c1262b2q803b0b8b6f1c5bdb@mail.gmail.com>
Date: Thu, 8 Oct 2009 14:14:58 +0200
Message-ID: <63386a3d0910080514s2c31377ft8bb757a09a5bc36@mail.gmail.com>
Subject: Re: [PATCH 1/2] Add COH 901 318 DMA block driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/30 Dan Williams <dan.j.williams@intel.com>:

> On Wed, Sep 30, 2009 at 2:37 AM, Linus Walleij
> <linus.ml.walleij@gmail.com> wrote:
>> 2009/9/22 Linus Walleij <linus.walleij@stericsson.com>:
>>
>>> This patch adds support for the ST-Ericsson COH 901 318 DMA block,
>>> found in the U300 series platforms. It registers a DMA slave for
>>> device I/O and also a memcpy slave for memcpy.
>>
>> Are there no further comments on this DMA driver or are the subsystem
>> maintainers simply busy right now?
>>
>
> With the merge window and Plumber's I have been distracted.  I'll take
> a look and send feedback in the next day or so.

Any news on this Dan? We'll post v2 soon:ish anyway so you can hold
until v2.

Linus Walleij
