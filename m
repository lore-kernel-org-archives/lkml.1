Return-Path: <linux-kernel-owner+w=401wt.eu-S1759797AbYBOShf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797AbYBOShf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYBOSh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:37:28 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:36362 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbYBOSh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:37:27 -0500
Date: Fri, 15 Feb 2008 12:37:26 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [Patch 4/5] IPMI: Style fixes in the system interface code
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Rocky Craig <rocky.craig@hp.com>, Hannes Schulz <schulz@schwaar.com>
Reply-to: minyard@acm.org
Message-id: <20080215183726.GB30335@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Lots of style fixes for the IPMI system interface driver.  No
functional changes.  Basically fixes everything reported by checkpatch
and fixes the comment style.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Rocky Craig <rocky.craig@hp.com>
Cc: Hannes Schulz <schulz@schwaar.com>

Patch is too big for the list, per the Submitting Patches document.  It
is available at:
http://mysite.verizon.net/tcminyard/ipmi-system-interface-style-fixes.patch
