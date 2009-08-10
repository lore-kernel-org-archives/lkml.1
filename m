Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbZHJHrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbZHJHrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 03:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZHJHrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 03:47:42 -0400
Received: from smtp.nokia.com ([192.100.105.134]:61915 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZHJHrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 03:47:41 -0400
Subject: Re: [PATCH v2 0/6] Device table matching for SPI subsystem
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: avorontsov@ru.mvista.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben@fluff.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20090731003957.GA23982@oksana.dev.rtsoft.ru>
References: <20090731003957.GA23982@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Aug 2009 10:35:23 +0300
Message-Id: <1249889723.19638.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Aug 2009 07:37:03.0519 (UTC) FILETIME=[5AA2EAF0:01CA198D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-31 at 04:39 +0400, Anton Vorontsov wrote:
> Andrew,
> 
> This new patch set overwrites following patches:
> 
>   hwmon-lm70-convert-to-device-table-matching.patch
>   hwmon-adxx-convert-to-device-table-matching.patch
>   spi-merge-probe-and-probe_id-callbacks.patch
>   spi-prefix-modalias-with-spi.patch
>   of-remove-stmm25p40-alias.patch
>   mtd-m25p80-convert-to-device-table-matching.patch
>   spi-add-support-for-device-table-matching.patch

Are you going to send v3 and address David's comments?
Do you want some of these patches to go via the MTD tree or
they better go as a series via some other tree?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

