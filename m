Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbYJOLjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbYJOLjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 07:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYJOLjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 07:39:37 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:48398 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbYJOLjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 07:39:36 -0400
Subject: Re: [PATCH] regulator: Build on non-ARM platforms
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1224068014-24845-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1224068014-24845-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 12:39:34 +0100
Message-Id: <1224070774.6814.414.camel@dell-desktop.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-15 at 11:53 +0100, Mark Brown wrote:
> When the regulator API was merged it was added to the separate Kconfig
> which ARM uses for drivers but not the generic one in drivers/.  Since
> there is nothing ARM-specific about the API add it there too.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam


