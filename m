Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbYHTLK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbYHTLK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 07:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYHTLKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 07:10:47 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:30542 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYHTLKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 07:10:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xzuJzWI/JEocuwvZCcYMQ8QdfO+4Gwxqs6uC9yoJw25sgYrHWM1g+8rRfaPUGNxL2n
         26ClBBANLPGi9YBT8S3m46zXL2M42bIhY3ijrDsZyqOaw+w3syyLRDqNQ+7sKqo/qS8r
         wsCij9DAeN3NQfmLOJpruY2NkssOWTw5wKSpM=
Message-ID: <b170af450808200410v3d7cd076h3e62546b48ddf507@mail.gmail.com>
Date: Wed, 20 Aug 2008 13:10:44 +0200
From: "=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?=" <zajec5@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [Bug #11313] Plugging HDMI causes "unable to handle kernel paging request"
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <48AB5D17.5030600@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
	 <sNRO-BDDjQL.A.DYF.sazpIB@albercik>
	 <b170af450808171228i37951c6vd77071da7584669b@mail.gmail.com>
	 <48AB5D17.5030600@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7KBB0dq007530

2008/8/19, Jeremy Fitzhardinge <jeremy@goop.org>:> What's your .config on this kernel, BTW?
I mostly used openSUSE's kernel configuration. I just disabled paravirt.http://bugzilla.kernel.org/attachment.cgi?id=17329

2008/8/20, Jeremy Fitzhardinge <jeremy@goop.org>:> RafaÅ‚ MiÅ‚ecki wrote:>> Bug still exists in current git (tested 15 minutes ago).>>>> Could you apply this patch and post the output of dmesg from booting (no> need to crash it again).
Sure, as everything to help debugging this :)http://bugzilla.kernel.org/attachment.cgi?id=17330
-- RafaÅ‚ MiÅ‚eckiÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
