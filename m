Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbXKSHqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbXKSHqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 02:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbXKSHp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 02:45:58 -0500
Received: from etc.kandalaya.org ([83.143.86.98]:53812 "EHLO
	images.kandalaya.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbXKSHp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 02:45:57 -0500
X-Greylist: delayed 979 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2007 02:45:57 EST
From: Raj Mathur <raju@linux-delhi.org>
Reply-To: raju@linux-delhi.org
Organization: Kandalaya
To: linux-kernel@vger.kernel.org
Subject: Query on kernel metrics available
Date: Mon, 19 Nov 2007 12:59:26 +0530
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711191259.26502.raju@linux-delhi.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A competing OS vendor is claiming that the Linux kernel has no way to 
measure the following:

a. Time spent waiting for page faults in percent

b. Total transfer time for each auxiliary memory in percent

c. Time in percent when one or more tasks were blocked waiting for 
memory resources

d. Time spent waiting for page faults in percent

I was wondering if the claims were pure FUD or are measurements 
possible -- whether they are actually implemented or not is not 
important (at least at this stage).  Apologies if the descriptions 
aren't very precise; OTOH that leaves us room to interpret the claims 
in a favourable (to us) manner :)

TIA and regards,

-- Raju
-- 
Raj Mathur                raju@kandalaya.org      http://kandalaya.org/
 Freedom in Technology & Software || February 2008 || http://freed.in/
       GPG: 78D4 FC67 367F 40E2 0DD5  0FEF C968 D0EF CC68 D17F
PsyTrance & Chill: http://schizoid.in/   ||   It is the mind that moves
