Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbYJMF15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbYJMF15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 01:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYJMF1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 01:27:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:4417 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbYJMF1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 01:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JDM+NlUOemnJpKWxfFWv6Hch4QDvyGIzTq5A+iu/kthTRDLIUD/t+SijxGAgMi2x2B
         1/C47pliQWiQqJT6ZUWBlAIpXQKuOb7AcaEFDz836EWBE7bdQ6kkpYmya9o0aagborr9
         Dc65gZePZkBVDoNHYRSygWJKVN0jy2yRCA5yI=
Message-ID: <a8e1da0810122227g3c44a4c1w7ee4d8a4e7548872@mail.gmail.com>
Date: Mon, 13 Oct 2008 13:27:47 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Arkadiusz Miskiewicz" <a.miskiewicz@gmail.com>
Subject: Re: oops while booting with recent git kernel
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200810121227.09114.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <200810121227.09114.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9D5S1dq007392

On Sun, Oct 12, 2008 at 6:27 PM, Arkadiusz Miskiewicz<a.miskiewicz@gmail.com> wrote:>> Not sure if it's worth to report this before all initial merges happen but> here it is anyway.
I saw similar oops while "reboot" with eip "strnlen", but only once.My kernel version is 2.6.27
>> git kernel with latest commit:> commit fd048088306656824958e7783ffcee27e241b361> Date:   Sat Oct 11 13:23:48 2008 -0700>> booted on thinkpad z60m results with such oops:> http://carme.pld-linux.org/~arekm/img_2325_small.png>> Config used:> http://carme.pld-linux.org/~arekm/img_2325_small.config>> --> Arkadiusz MiÅ›kiewicz        PLD/Linux Team> arekm / maven.pl            http://ftp.pld-linux.org/> --> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in> the body of a message to majordomo@vger.kernel.org> More majordomo info at  http://vger.kernel.org/majordomo-info.html> Please read the FAQ at  http://www.tux.org/lkml/>


-- Regardsdaveÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
