Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYDWMcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYDWMcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYDWMcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:32:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:16922 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123AbYDWMcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:32:24 -0400
Date: Wed, 23 Apr 2008 14:32:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: alek du <alek.du@intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] i2c: Add Intel SCH I2C SMBus support
Message-ID: <20080423143212.36dba2ea@hyperion.delvare>
In-Reply-To: <20080422100420.3ee5f150@dxy.sh.intel.com>
References: <20080422100420.3ee5f150@dxy.sh.intel.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alek,

On Tue, 22 Apr 2008 10:04:20 +0800, alek du wrote:
> This patch adds Intel SCH chipsets (US15W, US15L, UL11L) i2c bus support.

What kind of machines are these?

> 
> Signed-off-by: Alek Du <alek.du@intel.com>
> ---
>  drivers/i2c/busses/Kconfig   |    7 +
>  drivers/i2c/busses/Makefile  |    1 +
>  drivers/i2c/busses/i2c-sch.c |  419 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 427 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/busses/i2c-sch.c
> (...)

MAINTAINERS says:

I2C SUBSYSTEM
(...)
L:	i2c@lm-sensors.org

So it would be great if you could send your patch there rather than on
LKML.

Thanks,
-- 
Jean Delvare
