Return-Path: <linux-kernel-owner+w=401wt.eu-S1761089AbXJYUcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089AbXJYUcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXJYUck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:32:40 -0400
Received: from main.gmane.org ([80.91.229.2]:53272 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbXJYUcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:32:39 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [2.6.25 patch] the planned eepro100 removal
Date: Thu, 25 Oct 2007 16:42:18 -0400
Message-ID: <4720FFAA.9080709@tmr.com>
References: <20071024162440.GN30533@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: netdev@vger.kernel.org
X-Gmane-NNTP-Posting-Host: pool-70-109-100-63.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <20071024162440.GN30533@stusta.de>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch contains the planned removal of the eepro100 driver.
> 
Are the e100 people satisfied that e100 now handles all known cases? I 
remember that there were corner cases e100 didn't handle, have they all 
been fixed?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

