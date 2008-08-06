Return-Path: <linux-kernel-owner+w=401wt.eu-S1761970AbYHFUsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761970AbYHFUsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbYHFUs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:48:28 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:60537 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbYHFUs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:48:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ihl/04XuXLkLFFHXkNuXKlWXL03/Y42Z830tGqDuOUFUhtI0NKf2Lj9Ug8VVKfMfz6
         tfmf2W8kxlS3mw6o9EC0QeDv19mQeDHQjBkONRVPe9Q63RNaO0H5Ua8ONLzSIEFJWLjn
         FtL9wMgkiIRLUKnhXQHL0HsH6tmIiWSgApK6w=
Message-ID: <d77765540808061348u58cfe6a3pa437a9501bb9abff@mail.gmail.com>
Date: Wed, 6 Aug 2008 20:48:25 +0000
From: "=?UTF-8?Q?Piotr_Jaroszy=C5=84ski?=" <p.jaroszynski@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: HZ from userspace
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m76KmfIG013141

Hello,
I want to be able to convert starttime from /proc/#/stat to absolutetime and it seems that I need HZ to do that as it is measured injiffies. How can I get HZ? I have seen some discussion about this buthaven't found a definite answer. procps is using some hacks do it andI would prefer to avoid them.I only need a solution for modern kernels, say 2.6.20+ if that matters.
-- Best Regards,Piotr JaroszyÅ„skiÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
