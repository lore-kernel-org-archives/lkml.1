Return-Path: <linux-kernel-owner+w=401wt.eu-S1032676AbXHMSJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032676AbXHMSJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S974248AbXHMR47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:56:59 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3349 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S974245AbXHMR4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:56:55 -0400
Subject: Re: [PATCH] [231/2many] MAINTAINERS - I2C SUBSYSTEM
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org, akpm@linux-foundation.org
In-Reply-To: <20070813115921.1fac3ccd@hyperion.delvare>
References: <46bffa2e.Gcwew3sHyZdFHycV%joe@perches.com>
	 <20070813115921.1fac3ccd@hyperion.delvare>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 10:56:05 -0700
Message-Id: <1187027765.10249.184.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 11:59 +0200, Jean Delvare wrote:
> As far as the i2c subsystem itself is concerned, the relevant header
> files are only:
> F: include/linux/i2c.h
> F: include/linux/i2c-dev.h
> F: include/linux/i2c-id.h

I2C SUBSYSTEM
P:	Jean Delvare
M:	khali@linux-fr.org
L:	i2c@lm-sensors.org
T:	quilt http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/
S:	Maintained
F:	Documentation/i2c/
F:	drivers/i2c/
F:	include/linux/i2c.h
F:	include/linux/i2c-dev.h
F:	include/linux/i2c-id.h


