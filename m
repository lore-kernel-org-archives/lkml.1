Return-Path: <linux-kernel-owner+w=401wt.eu-S1751521AbYLMRdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbYLMRdh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 12:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbYLMRd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 12:33:27 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:35980 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYLMRd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 12:33:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JoMPTC4XeEbRxT6LGGOmPo3RIFfsZFczhjXMtFwbDkicTyWsHaW2bXAHfY3iIimtKE
         2TIf5JeyRyXHqIhql/xZjbsmdAOoloQX97qUCp/pXwP4BKHGvdtkEZr+2SngugqDYf5Y
         u4JqwYd7V3YkEwc50zh/4qn4CY10wnwBdmGus=
Message-ID: <2aac3c260812130933o7af36a56m12fef2d1c2cfa501@mail.gmail.com>
Date: Sat, 13 Dec 2008 18:33:25 +0100
From: "Giangiacomo Mariotti" <giangiacomo.mariotti@gmail.com>
To: "=?UTF-8?Q?Fr=C3=A9d=C3=A9ric_Weisbecker?=" <fweisbec@gmail.com>
Subject: Re: [PATCH] Misuse of sizeof
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <c62985530812130843q21142a2uf8e24482da90a8ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <2aac3c260812130831m3ec4aa5cm3abd729499727873@mail.gmail.com>
	 <c62985530812130843q21142a2uf8e24482da90a8ae@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mBDHXmdq025304

On 12/13/08, FrÃ©dÃ©ric Weisbecker <fweisbec@gmail.com> wrote:> 2008/12/13 Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>:>> IMO there's a bug in the use of sizeof in /arch/x86/boot/main.c, it's>> also a strange style.>>>> Hi,>> No this is not a bug, sizeof is a unary operator which can be used> with or without parenthesis :-)>> Note: don't forget to put your Signed-off-by and some explanations> along your patches.> Also, not all maintainers accept patches as attachment.>You're right, I was wrong.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
