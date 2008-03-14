Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYCNJbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYCNJbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 05:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757062AbYCNJaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 05:30:52 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:55041 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbYCNJav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 05:30:51 -0400
Message-Id: <20080314092523.147382820@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Mar 2008 10:25:23 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: [patch 0/2] CEX2C hardware random numbers.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
the two patches in this set allow Linux on System z to access the hardware
random generator on the CEX2C crypto cards. Patch #1 adds error checking
to the hwrng core to deal with i/o errors. Patch #2 adds the actual CEX2C
support.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

