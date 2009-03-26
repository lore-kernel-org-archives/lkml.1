Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbZCZJ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbZCZJ5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZCZJ50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:57:26 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:33278 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbZCZJ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:57:25 -0400
Message-ID: <49CB5165.4060401@in.ibm.com>
Date: Thu, 26 Mar 2009 15:26:53 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       heiko.carstens@de.ibm.com
Subject: Next March 26: s390 allnoconfig build failure still exists
References: <20090326190130.54fc6fde.sfr@canb.auug.org.au>
In-Reply-To: <20090326190130.54fc6fde.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I still see the following s390 allnoconfig build failure
with today's next (and previous trees as well ).

arch/s390/include/asm/smp.h:96: error: redefinition of smp_send_stop
include/linux/smp.h:125: error: previous definition of smp_send_stop was here



-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

