Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZDTGSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZDTGSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 02:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZDTGR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 02:17:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:22843 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbZDTGR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 02:17:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OQWcZjLxN8YYpANSYuQQ6vCHOsPP6DXvQ1aymRguA9imTvA68FGQXWJadcpjkwi7xt
         Fd+PxHV2yfdrDJGbEjJM1WpBBY6sn/3oUag39Ilru6neFiJ504vWVjUCmjg96LZiaPMG
         2c5i/uH9mknGeZ4EPSNg3uB/nC6BUdA7wqM7I=
MIME-Version: 1.0
In-Reply-To: <86802c440904192215k4a2fedb1s9587cee52d685f5b@mail.gmail.com>
References: <8db1092f0904171003u462b9d90pe874cd63c7a22a1d@mail.gmail.com>
	 <86802c440904192215k4a2fedb1s9587cee52d685f5b@mail.gmail.com>
Date: Mon, 20 Apr 2009 08:17:54 +0200
Message-ID: <8db1092f0904192317xeb6d961k5889edf0365a5077@mail.gmail.com>
Subject: Re: Spontaneous reboots since 2.6.29-rc*
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/20 Yinghai Lu <yhlu.kernel@gmail.com>:

>
> maybe you could enable
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>

I will check latest git, if that reboots still exists.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
