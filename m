Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbXL1MOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbXL1MOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 07:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbXL1MOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 07:14:38 -0500
Received: from crazy.xmat.net ([91.121.11.163]:53633 "EHLO
	tchaikovsky.artsenscene.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544AbXL1MOh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 07:14:37 -0500
To: jonsmirl@gmail.com
Subject: Re: [PATCH 0/5] Version 17,  series to add device tree naming to i2c
X-IlohaMail-Blah: khali@gcu-squad.org
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.14 (On: mail.gcu-squad.org)
Message-ID: <uyqq2ui6.1198844066.4263970.khali@gcu-squad.org>
In-Reply-To: <9e4733910712270847j35778e43i66fda3eca9dc125@mail.gmail.com>
From: "Jean Delvare" <khali@linux-fr.org>
Bounce-To: "Jean Delvare" <khali@linux-fr.org>
CC: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Date: Fri, 28 Dec 2007 13:14:28 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi John,

Le 27/12/2007, Jon Smirl écrit:
>On 12/19/07, Jon Smirl <jonsmirl@gmail.com> wrote:
>> Another rework of the i2c for powerpc device tree patch. This version implements standard alias naming only on the powerpc platform and only for the device tree names. The old naming mechanism of i2c_client.name,driver_name is left in place and not changed for non-powerpc platforms. This patch is fully capable of dynamically loading the i2c modules. You can modprobe in the i2c-mpc driver and the i2c modules described in the device tree will be automatically loaded. Modules also work if compiled in.
>
>Are there any further objections to this patch? Can it all go in
>through the powerpc trees or do the i2c people want to send it on?

I am on vacation until January 4th. I will review your patchset the week
following my return.

Thanks for your patience,
--
Jean Delvare
