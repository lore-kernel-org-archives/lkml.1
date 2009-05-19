Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZESQYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZESQYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 12:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZESQYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 12:24:16 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:52699 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbZESQYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 12:24:14 -0400
Date: Tue, 19 May 2009 21:53:53 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [Patch 0/2] Improvements and fixes to HW Breakpoint interface
Message-ID: <20090519162353.GA26009@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,
	Please find a couple of patches that contain improvements to the HW Breakpoint
interface code (discovered while porting the infrastructure on another architecture)
and a minor fix - the details of which are described in the patch header.

These patches can be applied over the patchset submitted over -tip here:
http://lkml.org/lkml/2009/5/15/139.

As they carry some of your suggestions, I will be glad to have it reviewed by you.

Hi Frederic,
	There's a minor style issue in the ksym tracer plugin (declaration of a
function in .c file) which has now been corrected. Kindly review the same.

Thanks,
K.Prasad

