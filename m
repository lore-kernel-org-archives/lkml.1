Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbYJGKRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbYJGKRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYJGKRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:17:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44137 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbYJGKR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:17:29 -0400
Date: Tue, 7 Oct 2008 12:17:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] Add a reference to paper to SubmittingPatches
Message-ID: <20081007101728.GA25620@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a reference to paper to SubmittingPatches

For this year's OLS I wrote a paper on successfull strategies
to submit difficult kernel patches. Add a reference to it to
SubmittingPatches.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.27-rc4-misc/Documentation/SubmittingPatches
===================================================================
--- linux-2.6.27-rc4-misc.orig/Documentation/SubmittingPatches
+++ linux-2.6.27-rc4-misc/Documentation/SubmittingPatches
@@ -672,4 +672,9 @@ Kernel Documentation/CodingStyle:
 
 Linus Torvalds's mail on the canonical patch format:
   <http://lkml.org/lkml/2005/4/7/183>
+
+Andi Kleen, "On submitting kernel patches"
+  Some strategies to get difficult or controversal changes in.
+  http://halobates.de/on-submitting-patches.pdf
+
 --
