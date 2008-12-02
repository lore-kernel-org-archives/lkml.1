Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbYLBATy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbYLBATy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 19:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbYLBATZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 19:19:25 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:49392 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbYLBATX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 19:19:23 -0500
Subject: [Patch 0/3] Overview, OProfile SPU event profiling support for IBM
	Cell processor
From: Carl Love <cel@us.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev <cbe-oss-dev@ozlabs.org>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 16:18:26 -0800
Message-Id: <1228177106.6509.285.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a rework of the previously posted set of patches.

Patch 1 is the user level patch to add the SPU events to the user
OProfile tool.  

Patch 2 is a kernel patch to do code clean up and restructuring to make
it easier to add the new SPU event profiling support.  This patch makes
no functional changes.

Patch 3 is a kernel patch to add the SPU event profiling support.

               Carl Love

