Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbZKBR2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbZKBR2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZKBR2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:28:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46738 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752599AbZKBR2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:28:37 -0500
Date: Mon, 2 Nov 2009 17:28:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       sameo@linux.intel.com, linux-kernel@vger.kernel.org, tony@atomide.com
Subject: Re: [PATCH 4/5] ASoC: TWL4030: Make sure, that the codec is
 powered on startup
Message-ID: <20091102172841.GB8546@rakim.wolfsonmicro.main>
References: <1257165295-9352-1-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-2-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-3-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-4-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-5-git-send-email-peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257165295-9352-5-git-send-email-peter.ujfalusi@nokia.com>
X-Cookie: Humpty Dumpty was pushed.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 02:34:54PM +0200, Peter Ujfalusi wrote:
> Set the codec->bias_level to SND_SOC_BIAS_OFF before changing
> the initial bias level to STANDBY.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>

I've applied this one immediately since it doesn't need any of the other
stuff.
