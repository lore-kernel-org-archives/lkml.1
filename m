Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYIOVN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYIOVN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbYIOVLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:11:40 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:43888 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917AbYIOVLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:11:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OURqzJ6muw2bbnoDCnaqcbkSkpaZhXvMbhY5U/ebAeXGnz3XfCu8TQH2s5S2GYEcS5
         dtAEx64x1yKLzCjgrBBtDP1wO9MUcXHIKkmdS0eUzYIbWEr9VX4b9N5YCg4CO/6ePMk9
         bWuTtdsuT/1ZUlf+l9uoa5ubtbHwrj6bPDNtk=
Message-ID: <43e72e890809151411h60a2379cw1fd2959794b97771@mail.gmail.com>
Date: Mon, 15 Sep 2008 14:11:37 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jouni Malinen" <j@w1.fi>
Subject: Re: adm8211 driver usage
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       "Michael Wu" <flamingice@sourmilk.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <48CECF5D.7070605@w1.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890809151359n45c5ecdateff5a4eed3f4067e@mail.gmail.com>
	 <48CECF5D.7070605@w1.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 2:10 PM, Jouni Malinen <j@w1.fi> wrote:
> Luis R. Rodriguez wrote:
>>
>> Just curious, anyone using the adm8211 driver? My understanding was
>> there was not much hardware out -- if any at all -- for it. If no one
>> is using it maybe we can remove it. I don't know a single soul using
>> it except maybe Michael and maybe a year ago.
>
> Umm.. Sure there is hardware out there and I would assume the driver is
> used, too. I have a card at home, but don't really use it that much.
> Anyway, I don't see any justification for removing the driver.

Thanks, didn't know it was, from what Michael had told me it was *very
rare* that's why I asked

 Luis
