Return-Path: <linux-kernel-owner+w=401wt.eu-S932471AbYARV5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbYARV5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbYARV5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:57:18 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:61541 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761501AbYARV5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:57:17 -0500
Date: Fri, 18 Jan 2008 21:57:15 +0000
From: Ben Dooks <ben@fluff.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Core driver for WM97xx touchscreens
Message-ID: <20080118215715.GB27399@fluff.org.uk>
References: <20080118162627.GA28974@rakim.wolfsonmicro.main> <1200673631-366-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20080118120148.ZZRA012@mailhub.coreip.homeip.net> <fmqq50$te0$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fmqq50$te0$1@ger.gmane.org>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 06:11:45PM +0000, Dmitry Baryshkov wrote:
> Hi,
> 
> Dmitry Torokhov wrote:
> 
> > I will need some more time to review and understand the need for the new
> > bus in the driver.
> 
> Most likely this can be converted to platform_bus. Maybe this can also get
> help from soon-to-be posted MFD (multi function devices) helpers.

Is there any current discussion of these in public? I'm interested
mainly due to my involvement in the SM501 core and FB driver. Can
I also request to be Cc'd when these are posted?

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
