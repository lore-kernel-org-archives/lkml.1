Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZLHSyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZLHSyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 13:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbZLHSyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 13:54:12 -0500
Received: from mail.perches.com ([173.55.12.10]:1080 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155AbZLHSyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 13:54:11 -0500
Subject: Re: [PATCH] MAINTAINERS: Update file patterns for WOLFSON
 MICROELECTRONICS PMIC DRIVERS
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091208185132.GA2590@opensource.wolfsonmicro.com>
References: <1260298117.27677.61.camel@Joe-Laptop.home>
	 <20091208185132.GA2590@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 10:54:17 -0800
Message-ID: <1260298457.27677.63.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 18:51 +0000, Mark Brown wrote:
> On Tue, Dec 08, 2009 at 10:48:37AM -0800, Joe Perches wrote:
> > One of the includes pointed to a non-existent directory
> > Add Documentation/hwmon/wm8350
> Why not Documentation/hwmon/wm831x?

Beats me, it's your entry, add all the appropriate ones.
Maybe:

F:	Documentation/hwmon/wm8*


