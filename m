Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbXFVQGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbXFVQGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbXFVQGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:06:13 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:37822 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002AbXFVQGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:06:10 -0400
Date: Fri, 22 Jun 2007 18:06:12 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Ville =?utf-8?B?U3lyasOkbMOk?= <syrjala@sci.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: mach64 breakage in 2.6.22
Message-ID: <20070622160612.GA2451@aepfle.de>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <20070614082528.GA10284@aepfle.de> <20070614173623.GA7950@sci.fi> <20070618144534.GA18150@aepfle.de> <20070621172514.GA11766@sci.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070621172514.GA11766@sci.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, Ville Syrjälä wrote:

> Here's a slightly safer version, just in case there are iBooks with
> non-mobility chips or using the 64bit memory interface.
> 
> 
> atyfb: Fix XCLK frequency on Apple iBook1
> 
> Fix a regression on Apple iBook1. Changes in the clock init code
> caused an incorrect XCLK frequency to be used leading to a corrupted
> display.

Yes, this one fixes it too.
