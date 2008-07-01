Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbYGAQhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbYGAQhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYGAQhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:37:05 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35914 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbYGAQhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:37:04 -0400
Subject: x86: unifying the 32 and 64 bit machine check handlers
From: Max Asbock <masbock@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>, mingo <mingo@redhat.com>,
       hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 09:37:03 -0700
Message-Id: <1214930223.20425.48.camel@w-amax.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is anybody currently working on combining the machine check handlers for
32-bit and 64-bit x86? If there is interest I could post some rough
patches to get this started. 

thanks,
Max



