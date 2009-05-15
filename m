Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbZEOITf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbZEOITf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbZEOITT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:19:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36695 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756031AbZEOITS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:19:18 -0400
Date: Fri, 15 May 2009 09:19:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: lrg@slimlogic.co.uk, lkml <linux-kernel@vger.kernel.org>,
       DaVinci <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [patch 0/3] DaVinci ASoC updates
Message-ID: <20090515081917.GA29556@rakim.wolfsonmicro.main>
References: <200905141235.35600.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905141235.35600.david-b@pacbell.net>
X-Cookie: WRONG!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 12:35:35PM -0700, David Brownell wrote:

> The 2.6.30-rc5 merges included a bunch of DaVinci platform
> updates, including EDMA support.  Which means that finally
> the ASoC stuff can be made to build in mainline ... it was
> probably sent to mainline before its time.  ;)

I've applied all three patches.  Obviously they should all have been
merged much earlier but given that the code didn't even build there's
no risk of making the situation worse and they look fine.

> (I'm cc'ing all interested parties -- except alsa-devel,
> which is members-only -- on this note, but will only cc
> the DaVinci list on the three patches.)

In future I'd suggest not sending the cover letter to more recipients
than the actual patches, it just creates confusion.
