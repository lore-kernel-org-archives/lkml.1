Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbYA2WES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbYA2WES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYA2WEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:04:07 -0500
Received: from main.gmane.org ([80.91.229.2]:51721 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbYA2WEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:04:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [UPDATED v4] WM97xx touchscreen drivers
Date: Tue, 29 Jan 2008 22:03:56 +0000 (UTC)
Message-ID: <fno7sc$e5m$1@ger.gmane.org>
References: <20080126151820.GA13899@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp89-110-61-229.pppoe.avangarddsl.ru
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-input@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:

> This patch series adds support for the touchscreen controllers provided
> by Wolfson Microelectronics WM97xx series chips in both polled and
> streaming modes.
> 
> Changes since last submission:
>  - Fix from Dmitry Baryshkov for build with CONFIG_PM. - Add the web
>  site to the MAINTAINERS entry.

Thanks. This serie "worksforme". Is it going to be merged during this window?

-- 
With best wishes
Dmitry


