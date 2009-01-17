Return-Path: <linux-kernel-owner+w=401wt.eu-S1765199AbZAQC5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765199AbZAQC5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZAQC4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:56:53 -0500
Received: from kuber.nabble.com ([216.139.236.158]:47669 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbZAQC4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:56:53 -0500
Message-ID: <21512362.post@talk.nabble.com>
Date: Fri, 16 Jan 2009 18:56:52 -0800 (PST)
From: sidc7 <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel vs user memory
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: siddhartha.chhabra@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The kernel maintains a free list of pages that are free in physical memory. I
was wondering, are these pages in the kernel space ? They are not mapped to
any of the user address space for sure, so will they be in the kernel memory
?

Thanks
-- 
View this message in context: http://www.nabble.com/Kernel-vs-user-memory-tp21512362p21512362.html
Sent from the linux-kernel mailing list archive at Nabble.com.

