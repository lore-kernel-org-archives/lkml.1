Return-Path: <linux-kernel-owner+w=401wt.eu-S1946046AbXDDBiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946046AbXDDBiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966263AbXDDBfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:35:54 -0400
Received: from 250.sub-75-209-50.myvzw.com ([75.209.50.250]:34560 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966252AbXDDBfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:35:34 -0400
Message-Id: <20070404010655.400913479@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 03 Apr 2007 18:06:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch 0/6] Various cleanups
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Here's a little batch of cleanups:
 - re-enable VDSO when PARAVIRT is enabled
 - make the parainstructions symbols match the
   other altinstructions naming convention
 - add kernel command-line options to disable altinstructions for
   smp and pv_ops

Oh, and I'm mailing your noreplacement patch back at you, for no
particularly good reason.

	J

-- 

