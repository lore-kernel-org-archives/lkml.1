Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYIDKsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYIDKsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 06:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYIDKrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 06:47:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37794 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752502AbYIDKry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 06:47:54 -0400
Date: Thu, 4 Sep 2008 11:47:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>
Subject: Re: [PATCH 3/9] ASoC: Blackfin: SPORT peripheral interface driver
Message-ID: <20080904104753.GC12775@rakim.wolfsonmicro.main>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	Cliff Cai <cliff.cai@analog.com>
References: <1220516528-20301-1-git-send-email-cooloney@kernel.org> <1220516528-20301-4-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220516528-20301-4-git-send-email-cooloney@kernel.org>
X-Cookie: All's well that ends.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 04:22:02PM +0800, Bryan Wu wrote:
> From: Cliff Cai <cliff.cai@analog.com>

> SPORT is a serial port which can support serveral serial communication protocols.
> It can be used as I2C/PCM/AC97. For further information, please look up the HRM.

> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

with the proviso that there's no ALSA or ASoC interfacing stuff in here
so I'm likely to miss stuff.
