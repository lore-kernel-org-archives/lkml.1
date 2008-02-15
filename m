Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbYBOSgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbYBOSgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbYBOSf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:35:58 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:34964 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbYBOSf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:35:58 -0500
Date: Fri, 15 Feb 2008 12:35:46 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [Patch 3/5] IPMI: Style fixes in the base code
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20080215183546.GA30335@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Lots of style fixes for the base IPMI driver.  No functional changes.
Basically fixes everything reported by checkpatch and fixes the comment
style.

Signed-off-by: Corey Minyard <cminyard@mvista.com>

Patch is too big for the list, per the Submitting Patches document.  It
is available at:

http://mysite.verizon.net/tcminyard/ipmi-style-fixes.patch
