Return-Path: <linux-kernel-owner+w=401wt.eu-S933875AbXC1WRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875AbXC1WRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933859AbXC1WRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:17:54 -0400
Received: from main.gmane.org ([80.91.229.2]:60841 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933875AbXC1WRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:17:53 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [2.6 patch] the scheduled eepro100 removal
Date: Wed, 28 Mar 2007 18:17:59 -0400
Message-ID: <460AE997.90509@tmr.com>
References: <20070325145810.GI16477@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <20070325145810.GI16477@stusta.de>
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch contains the scheduled removal of the eepro100 driver.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> 
This keeps coming around, but I haven't seen an answer to the questions 
raised by Eric Piel or Kiszka. I do know that e100 didn't work on some 
IBM rackmount servers and eepro100 did, but since I'm no longer 
responsible for those machines I can't retest. Perhaps someone will be 
able to provide data points.

IBM current offerings as of about three years ago, I had a few dozen of 
them at one time.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

