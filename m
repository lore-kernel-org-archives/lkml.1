Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbZKIWC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbZKIWC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZKIWCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:02:55 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61681 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbZKIWCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:02:55 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+8dMKPXnryR594QtStbHC8
Date: Mon, 9 Nov 2009 14:02:58 -0800
From: Tony Lindgren <tony@atomide.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>, alsa-devel@alsa-project.org,
       linux-omap@vger.kernel.org, sameo@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4 v2] ASoC/MFD/OMAP: TWL4030: APLL_CTL handling change
Message-ID: <20091109220258.GI23952@atomide.com>
References: <1257321500-27049-1-git-send-email-peter.ujfalusi@nokia.com>
 <20091104102040.GA25922@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104102040.GA25922@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Brown <broonie@opensource.wolfsonmicro.com> [091104 02:20]:
> On Wed, Nov 04, 2009 at 09:58:16AM +0200, Peter Ujfalusi wrote:
> 
> > The following series changes the way how the APLL_CTL register is handled by
> > the twl4030 codec related drivers.
> 
> I'm OK with this but I'll wait for acks from Tony and Samuel before
> applying.

Looks good to me, replied with my ack in the board-*.c files patch
in this series.

Regards,

Tony
