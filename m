Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbXLROkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbXLROkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 09:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbXLROkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 09:40:07 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:4982 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753203AbXLROkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 09:40:06 -0500
Date: Tue, 18 Dec 2007 15:40:04 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "eric miao" <eric.y.miao@gmail.com>
Cc: "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org, bgardner@wabtec.com
Subject: Re: [PATCH 2.6.24-rc5-mm 3/3] gpiolib: obsolete
 drivers/i2c/chips/pca9539.c
Message-ID: <20071218154004.738e7894@hyperion.delvare>
In-Reply-To: <f17812d70712171754q3b71a39dl7d17f5d9e5b8014c@mail.gmail.com>
References: <f17812d70712142016q73abffc2w99174c40f847152c@mail.gmail.com>
	<20071216204214.01fd7a16@hyperion.delvare>
	<f17812d70712162233h759432a9i15b8e12d1a5fb828@mail.gmail.com>
	<20071217180953.1BB8E16AF21@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20071217212953.260f7826@hyperion.delvare>
	<f17812d70712171754q3b71a39dl7d17f5d9e5b8014c@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Tue, 18 Dec 2007 09:54:42 +0800, eric miao wrote:
> Well, I guess it would be a smooth path if we rename the
> drivers/i2c/chips/pca9539.c
> since that's old style I2C driver, which means the driver name is not
> so useful external
> so the impact is actually minimum.

That's fine with me, just send me a patch.

-- 
Jean Delvare
