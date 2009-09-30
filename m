Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZI3N1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZI3N1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 09:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZI3N1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 09:27:00 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:51731 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbZI3N07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 09:26:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jlgfnkGdPibUXx3HwTHFPJz0Ey1PzSqsZws9a4afPPYNw5xCgjX62zQKesyvo0QTKn
         hyKhq/i6Dv1R1doE7BjJ2xe+V4RrA3jzCuBvVKg5Mr+JFI1TlqH1ZpZJH+b6r7yXQ80W
         sd/m8Zyaabban7RC5SEATcrXAi+a6RkmVdFWo=
Message-ID: <4AC35CA0.5070401@googlemail.com>
Date: Wed, 30 Sep 2009 15:26:56 +0200
From: Gonsolo <gonsolo@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
CC: Gonsolo <gonsolo@gmail.com>, kernel-team@lists.ubuntu.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: ath5k suspend
References: <4AC22B64.8050909@googlemail.com> <6278d2220909300536u7934d7dan286d219b5cf7e5a@mail.gmail.com>
In-Reply-To: <6278d2220909300536u7934d7dan286d219b5cf7e5a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Is it possible to add
>> http://patchwork.kernel.org/patch/38550/
>> to karmic? Otherwise karmic would be broken for me/my notebook/my
>> wireless pccard.
>
> Since Karmic tracks the 2.6.31 -stable kernels, it's worth reporting
> this upstream (CC'd) instead, particularly if it's a regression from a
> previous kernel version, using the same ath5k driver...?

I did that, too. ;) Hopefully it will be in 2.6.31.2.

g
