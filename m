Return-Path: <linux-kernel-owner+w=401wt.eu-S1762962AbZE1I73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762962AbZE1I73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbZE1I7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:59:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36472 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761954AbZE1I7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:59:20 -0400
Date: Thu, 28 May 2009 09:59:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Eric Miao <eric.miao@marvell.com>
Subject: Re: [PATCH 1/3] regulator/max1586: support increased V3 voltage
	range
Message-ID: <20090528085920.GA4624@rakim.wolfsonmicro.main>
References: <878wkibmv9.fsf@free.fr> <1243487718-5423-2-git-send-email-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243487718-5423-2-git-send-email-philipp.zabel@gmail.com>
X-Cookie: I'm rated PG-34!!
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 07:15:16AM +0200, Philipp Zabel wrote:
> The V3 regulator can be configured with an external resistor
> connected to the feedback pin (R24 in the data sheet) to
> increase the voltage range.
> 
> For example, hx4700 has R24 = 3.32 kOhm to achieve a maximum
> V3 voltage of 1.55 V which is needed for 624 MHz CPU frequency.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>

Looks good.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
