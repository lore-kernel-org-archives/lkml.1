Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZKZPrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZKZPrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 10:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbZKZPrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 10:47:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37779 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752690AbZKZPrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 10:47:41 -0500
Date: Thu, 26 Nov 2009 15:47:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: alsa-devel@alsa-project.org, sfr@canb.auug.org.au, tj@kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de
Subject: Re: [PATCH] ASoC: tlv320dac33: Change RT wq to singlethread wq
Message-ID: <20091126154746.GA10674@rakim.wolfsonmicro.main>
References: <1259236511-25805-1-git-send-email-peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259236511-25805-1-git-send-email-peter.ujfalusi@nokia.com>
X-Cookie: Bus error -- driver executed.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 01:55:11PM +0200, Peter Ujfalusi wrote:
> RT workqueue is going away in the near future, replace it with
> singlethread wq for now, which is still supported.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>

Applied, thanks.
