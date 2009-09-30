Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZI3XxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZI3XxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZI3XxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:53:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754454AbZI3XxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:53:20 -0400
Date: Wed, 30 Sep 2009 16:52:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: spi-devel-general@lists.sourceforge.net, dbrownell@users.sourceforge.net,
       s.hauer@pengutronix.de, g.liakhovetski@gmx.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Updates for spi-imx
Message-Id: <20090930165241.ecb2a83e.akpm@linux-foundation.org>
In-Reply-To: <20090930194211.GB1881@pengutronix.de>
References: <20090930194211.GB1881@pengutronix.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 21:42:11 +0200
Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de> wrote:

> as a followup to this mail I'll send some updates for the spi-imx
> driver for review.

Several of these patches were unchangelogged but afaict they all fix
bugs and hence should be in 2.6.32, yes?

Renaming the entire source file after -rc1 was probably a bit naughty,
but we'll survive.

