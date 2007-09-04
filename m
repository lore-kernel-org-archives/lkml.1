Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbXIDUsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbXIDUsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 16:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbXIDUsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 16:48:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbXIDUsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 16:48:10 -0400
Message-ID: <46DDC462.2040309@redhat.com>
Date: Tue, 04 Sep 2007 16:47:30 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Brown, Len" <len.brown@intel.com>
Subject: What's happening with the cpuidle code?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A look at the 'cpuidle' branch of git-acpi shows a commit
e40cede7d63a029e92712a3fe02faee60cc38fb4, "cpuidle: first
round of documentation updates" that doesn't show up in that
branch online. The entire Documentation/cpuidle directory
is missing from the tree when looking at the web pages, and
it's missing from git-acpi.patch in 2.6.23-rc4-mm1 (but the
patch shows up in the summary information in the patch
header.) Where did it go? And how can -mm be used to test
things if its patches don't even match their own headers?

