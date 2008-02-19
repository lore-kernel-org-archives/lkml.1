Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbYBSDJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbYBSDJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 22:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYBSDJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 22:09:33 -0500
Received: from emerald.lightlink.com ([205.232.34.14]:27176 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbYBSDJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 22:09:32 -0500
Date: Mon, 18 Feb 2008 22:06:02 -0500
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH v2] adt7473: New driver for Analog Devices
	ADT7473 sensor chip
Message-ID: <20080219030602.GA2859@jupiter.solarsys.private>
References: <20071219034116.GM6870@tree.beaverton.ibm.com> <20071219154759.7be5025c@hyperion.delvare> <20071219231437.GR6870@tree.beaverton.ibm.com> <20080217200250.GD2916@jupiter.solarsys.private> <20080218213322.GD5784@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218213322.GD5784@tree.beaverton.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick:

* Darrick J. Wong <djwong@us.ibm.com> [2008-02-18 13:33:23 -0800]:
> adt7473: New driver for Analog Devices ADT7473 sensor chip
> 
> This driver reports voltage, temperature and fan sensor readings
> on an ADT7473 chip.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  Documentation/hwmon/adt7473 |   79 +++
>  drivers/hwmon/Kconfig       |   10 
>  drivers/hwmon/Makefile      |    1 
>  drivers/hwmon/adt7473.c     | 1157 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 1247 insertions(+), 0 deletions(-)
> 

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

