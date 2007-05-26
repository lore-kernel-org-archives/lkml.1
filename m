Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbXEZNeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbXEZNeV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 09:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbXEZNeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 09:34:14 -0400
Received: from v6.netlin.pl ([62.121.136.6]:48734 "EHLO pointblue.com.pl"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbXEZNeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 09:34:14 -0400
X-Greylist: delayed 1699 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 May 2007 09:34:13 EDT
From: Tommy Vercetti <vercetti@zlew.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21.1 - 97% wait time on IDE operations
Date: Sat, 26 May 2007 15:05:38 +0200
User-Agent: KMail/1.9.3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261505.38109@gj-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks, 

I was trying to get answer to my question around, but no one knows.
I do have DMA turned on, etc, yet - on extensive harddrive operations wait 
time is 90+% , which means that machine is waiting, rather than doing 
something meanwhile. (I guess). 
Can someone describe to me , in more detail why is that happening, and what 
steps should I consider to avoid it ? I couldn't find any answers that would 
have help me on net.

thanks.
-- 
Vercetti
