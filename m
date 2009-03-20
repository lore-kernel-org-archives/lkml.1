Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbZCTJFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbZCTJFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 05:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZCTJFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 05:05:35 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:39571 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbZCTJFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 05:05:34 -0400
Message-ID: <49C35C56.1010205@in.ibm.com>
Date: Fri, 20 Mar 2009 14:35:26 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       dm-devel@redhat.com
Subject: Next March 20 : drivers/md/dm-exception-store build break
References: <20090320162800.24b0ad93.sfr@canb.auug.org.au>
In-Reply-To: <20090320162800.24b0ad93.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's next tree randconfig build failed with

  CC      drivers/md/dm-exception-store.o
drivers/md/dm-exception-store.c: In function dm_exception_store_type_unregister:
drivers/md/dm-exception-store.c:133: error: implicit declaration of function module_refcount

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

