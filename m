Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZINHZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZINHZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZINHZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:25:30 -0400
Received: from mail.perches.com ([173.55.12.10]:1150 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbZINHZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:25:26 -0400
Subject: Re: [PATCH v2] input/keyboard: new OpenCores Keyboard Controller
 driver
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Javier Herrero <jherrero@hvsistemas.es>,
       Bryan Wu <cooloney@kernel.org>
In-Reply-To: <1252911864-19233-1-git-send-email-vapier@gentoo.org>
References: <1252894678-26929-1-git-send-email-vapier@gentoo.org>
	 <1252911864-19233-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Sep 2009 00:25:29 -0700
Message-Id: <1252913129.4400.247.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 03:04 -0400, Mike Frysinger wrote:
> From: Javier Herrero <jherrero@hvsistemas.es>
> +#define pr_fmt(fmt) DRV_NAME ": " fmt

perhaps:
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt


