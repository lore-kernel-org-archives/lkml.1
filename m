Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZD0Mkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZD0Mkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbZD0Mk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:40:27 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:60084 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbZD0Mk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:40:27 -0400
Subject: Re: [PATCH v2] Maxim 1586 regulator driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
       philipp.zabel@gmail.com
In-Reply-To: <1240510243-28969-1-git-send-email-robert.jarzmik@free.fr>
References: <1240510243-28969-1-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain
Date: Mon, 27 Apr 2009 13:40:24 +0100
Message-Id: <1240836024.14165.10.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-23 at 20:10 +0200, Robert Jarzmik wrote:
> The Maxim 1586 regulator is a voltage regulator with 2
> voltage outputs, specially suitable for Marvell PXA
> chips. One output is in the range of required VCC_CORE by
> the PXA27x chips, the other in the VCC_USIM required as well
> by PXA27x chips.
> 
> The chip is controlled through the I2C bus.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

Applied with dependency on I2C.

Thanks

Liam


