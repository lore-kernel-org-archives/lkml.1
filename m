Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbYHGVPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbYHGVPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYHGVPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:15:14 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38627 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbYHGVPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:15:12 -0400
Message-ID: <489B65CC.2080803@us.ibm.com>
Date: Thu, 07 Aug 2008 14:14:52 -0700
From: Corey Ashford <cjashfor@us.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] adds POWER support to perfmon2 kernel patch of 6/30/08
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'd like to propose two additional patches to the "perfmon2 minimal v3" 
kernel patch set that Stephane Eranian posted to lkml on 6/30/2008.  See
http://marc.info/?l=linux-kernel&m=121483174521037&w=2

This patch set requires Stephane's patches, which are against Steven 
Rothwell's linux-next git tree at that time.  Because Steven's git tree 
has moved on substantially since that point in time, I decided to apply 
Stephane's patches to Steven's "next-20080630" tag, and then create 
patches on top of that.  Neither these patches nor Stephane's will apply 
cleanly to Steven Rothwell's current git tree.  Also, I should note that 
  the next-20080630 tagged source does not compile completely; there are 
some problems in an unrelated driver.

I'm posting these patches mostly for comment and feedback at this point,
since Stephane Eranian's patches have not been accepted yet.

I'd like to request that you cc me with any responses, though I will be 
monitoring the mailing list via archives.

This is my first post to lkml.org, so any comments about incorrect 
netiquette are welcome.

Thanks for your consideration,

- Corey

-- 
Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

