Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYIDKl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYIDKl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 06:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYIDKlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 06:41:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36033 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752658AbYIDKlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 06:41:50 -0400
Date: Thu, 4 Sep 2008 11:41:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>
Subject: Re: [PATCH 2/9] ASoC: Blackfin: add Blackfin arch ASoC Kconfig and
	Makefile
Message-ID: <20080904104147.GB12775@rakim.wolfsonmicro.main>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	Cliff Cai <cliff.cai@analog.com>
References: <1220516528-20301-1-git-send-email-cooloney@kernel.org> <1220516528-20301-3-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220516528-20301-3-git-send-email-cooloney@kernel.org>
X-Cookie: All's well that ends.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 04:22:01PM +0800, Bryan Wu wrote:
> From: Cliff Cai <cliff.cai@analog.com>
> 
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Normally this would be the last patch in the series since it's not much
good without the code to build :) .
