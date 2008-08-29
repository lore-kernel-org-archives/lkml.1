Return-Path: <linux-kernel-owner+w=401wt.eu-S1758289AbYH2WCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbYH2WCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYH2WCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:02:10 -0400
Received: from gherkin.frus.com ([192.158.254.49]:40779 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbYH2WCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:02:09 -0400
X-Greylist: delayed 1393 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 18:02:06 EDT
Date: Fri, 29 Aug 2008 16:38:24 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] /proc/mtrr I/O error
Message-ID: <20080829213824.GA2281@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.27-rc4 and possibly earlier kernels, I see the following:

$ cat /proc/mtrr
cat: /proc/mtrr: Input/output error

Processor is an AMD K6-III/450.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
