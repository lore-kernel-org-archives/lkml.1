Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbZF1XtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbZF1XtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 19:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZF1XtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 19:49:10 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:40581 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbZF1XtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 19:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RMr8gexBTVjp+9b5LIALELl9zTFhadtgAjDYyi2OnSyFJzi3PHoH2TwqlFCNPcKqEz
         1ncgZtywOG1K9LAR5q5/m15b2HI5L1fBzFMsoUVNaLuqZm/HwCTfky156RY290y7s1/v
         5pVW8bApABoVwTgWHo8XRwJwUTlL7dHFHt/5E=
MIME-Version: 1.0
In-Reply-To: <5d5443650906260322n3c4f5f79r3290ebce2e331234@mail.gmail.com>
References: <4A448926.1030701@samsung.com>
	 <5d5443650906260322n3c4f5f79r3290ebce2e331234@mail.gmail.com>
Date: Mon, 29 Jun 2009 08:49:10 +0900
Message-ID: <1f3430fb0906281649i1e4accdbh26efadc3f565a4e4@mail.gmail.com>
Subject: Re: [PATCH] hwmon: add GP2A002 proximity/ambient sensor
From: Minkyu Kang <promsoft@gmail.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Minkyu Kang <mk7.kang@samsung.com>, linux-kernel@vger.kernel.org,
       linux-i2c@vger.kernel.org, lm-sensors@lm-sensors.org,
       suchang.woo@samsung.com, kyungmin.park@samsung.com,
       linux-input@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trilok,

2009/6/26 Trilok Soni <soni.trilok@gmail.com>:
> Hi Minkyu,
>
> Adding linux-input ML, as driver is using linux input subsystem.
>
> On Fri, Jun 26, 2009 at 2:09 PM, Minkyu Kang<mk7.kang@samsung.com> wrote:
>> The GP2A002 is a I2C interfaced Sensor for Proximity/Ambient
>> This patch adds support the GP2A002 sensor
>>
>> Signed-off-by: Minkyu Kang <mk7.kang@samsung.com>
>> Signed-off-by: Suchang Woo <suchang.woo@samsung.com>
>> ---
>>  drivers/hwmon/Kconfig    |    7 +
>>  drivers/hwmon/Makefile   |    1 +
>>  drivers/hwmon/gp2ap002.c |  471 ++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/gp2ap002.h |   21 ++
>>  4 files changed, 500 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/hwmon/gp2ap002.c
>>  create mode 100644 include/linux/gp2ap002.h
>>

Thanks for review and I'll make new version as you said : )

-- 
from. prom.
www.promsoft.net
