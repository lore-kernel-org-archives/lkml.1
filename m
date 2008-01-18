Return-Path: <linux-kernel-owner+w=401wt.eu-S1764109AbYARSMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764109AbYARSMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762798AbYARSME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:12:04 -0500
Received: from main.gmane.org ([80.91.229.2]:49649 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762298AbYARSMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:12:03 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] Core driver for WM97xx touchscreens
Date: Fri, 18 Jan 2008 18:11:45 +0000 (UTC)
Message-ID: <fmqq50$te0$1@ger.gmane.org>
References: <20080118162627.GA28974@rakim.wolfsonmicro.main>
	<1200673631-366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20080118120148.ZZRA012@mailhub.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip-83-149-3-34.nwgsm.ru
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-input@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dmitry Torokhov wrote:

> I will need some more time to review and understand the need for the new
> bus in the driver.

Most likely this can be converted to platform_bus. Maybe this can also get
help from soon-to-be posted MFD (multi function devices) helpers.

-- 
With best wishes
Dmitry


