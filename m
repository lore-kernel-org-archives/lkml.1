Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab0BNBwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 20:52:09 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:49614 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758273Ab0BNBwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 20:52:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=tVEuzAQWcSaMeH3PDnf1At3bU9EqTlUf8iqMLyi1xxCXTW89+7IOHLCLUU6ullvJqH
         qXpXJfJS3YnK5VujVEu1dFMTsFY0bQ2JRUKVE9X5HKqoZSv75dnc37179ToKHwb9lw11
         J8CppX8HALuJ3ONGmDiwVFb4vBAH8QeAWY/Nc=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 02:51:59 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31.12r4; KDE/4.4.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002140251.59668.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>0.90 has a very bad problem, which is that it is hard to distinguish
>between a RAID partition at the end of volume and a full RAID device.
>This is because 0.90 doesn't actually tell you the start of the device.
>
>Then, of course, there are a lot of limitations on size, number of
>devices, and so on in 0.90.

but it is the only format supporting autodetection. 

So - when will autodetection be introduced with 1.X? And if not, why not?

All I found was 'autodetection might be troublesome' and nothing else.
 But dealing with initrds is troublesome too. Pure evil even. 

Glück Auf,
Volker
