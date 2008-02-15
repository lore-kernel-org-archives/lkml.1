Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbYBOSme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbYBOSme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbYBOSm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:42:27 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:34499 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbYBOSm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:42:26 -0500
Date: Fri, 15 Feb 2008 12:39:03 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [Patch 5/5] IPMI: Style fixes in the misc code
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20080215183903.GC30335@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Lots of style fixes for the miscellaneous IPMI files.  No functional
changes.  Basically fixes everything reported by checkpatch and fixes
the comment style.

Signed-off-by: Corey Minyard <cminyard@mvista.com>

Patch is too big for the list, per the Submitting Patches document.  It
is available at:
http://mysite.verizon.net/tcminyard/ipmi-misc-style-fixes.patch
