Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbZD0M3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbZD0M3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZD0M3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:29:31 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:36377 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZD0M3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:29:30 -0400
Subject: Re: [PATCH] regulator: add userspace-consumer driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mike Rapoport <mike@compulab.co.il>
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
In-Reply-To: <1240753779-28189-1-git-send-email-mike@compulab.co.il>
References: <20090426120036.GA10900@opensource.wolfsonmicro.com>
	 <1240753779-28189-1-git-send-email-mike@compulab.co.il>
Content-Type: text/plain
Date: Mon, 27 Apr 2009 13:29:28 +0100
Message-Id: <1240835368.14165.8.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-26 at 16:49 +0300, Mike Rapoport wrote:
> The userspace-consumer driver allows control of voltage and current
> regulator state from userspace. This is required for fine-grained
> power management of devices that are completely controller by userspace
> applications, e.g. a GPS transciever connected to a serial port.
> 
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>

Applied.

Thanks

Liam

