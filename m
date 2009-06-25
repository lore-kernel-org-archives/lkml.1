Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbZFYIGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbZFYIGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbZFYIFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:05:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56554 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZFYIFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:05:41 -0400
Date: Thu, 25 Jun 2009 10:05:42 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, linux@maxim.org.za,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 2/2] Fix typo s/parititions/partitions/
Message-ID: <20090625080542.GB2995@pengutronix.de>
References: <1245879646-10338-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1245879646-10338-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 24, 2009 at 06:40:46PM -0300, Thadeu Lima de Souza Cascardo wrote:
> -		printk(KERN_ERR "atmel_nand: No parititions defined, or unsupported device.\n");
> +		printk(KERN_ERR "atmel_nand: No partitions defined, or unsupported device.\n");
It's a nice idea to Cc: trivial@kernel.org for such patches.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
