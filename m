Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbXJ1Rqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbXJ1Rqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbXJ1Rqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:46:43 -0400
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:50170 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbXJ1Rqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:46:42 -0400
To: Bradley Smith <bradjsmith@btinternet.com>
Subject: Re: [PATCH 2/2] I8K: Adds i8k driver to the x86_64 Kconfig
Cc: dz@debian.org, linux-kernel@vger.kernel.org
In-reply-To: <20071028172613.236cac1b@debian.hob>
References: <20071028172613.236cac1b@debian.hob>
Message-Id: <E1ImCDg-0004N6-0s@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Sun, 28 Oct 2007 18:46:40 +0100
X-OriginalArrivalTime: 28 Oct 2007 17:46:40.0403 (UTC) FILETIME=[7ED37E30:01C8198A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bradley Smith wrote:
> +config I8K
> +     tristate "Dell laptop support"

Shouldn't that be config DELL_I8K, or even DELL_INSPIRON_8K?

Cheers,
Frans Pop
