Return-Path: <linux-kernel-owner+w=401wt.eu-S932328AbXK2OoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbXK2OoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 09:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbXK2OoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 09:44:04 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40838 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbXK2OoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 09:44:03 -0500
Message-ID: <474ED005.7060300@linux.vnet.ibm.com>
Date: Thu, 29 Nov 2007 20:13:17 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Linux Memory Management List <linux-mm@kvack.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelianov <xemul@sw.ru>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Rik van Riel <riel@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       "Martin J. Bligh" <mbligh@google.com>,
       Andy Whitcroft <andyw@uk.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: What can we do to get ready for memory controller merge in 2.6.25
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

They say better strike when the iron is hot.

Since we have so many people discussing the memory controller, I would
like to access the readiness of the memory controller for mainline
merge. Given that we have some time until the merge window, I'd like to
set aside some time (from my other work items) to work on the memory
controller, fix review comments and defects.

In the past, we've received several useful comments from Rik Van Riel,
Lee Schermerhorn, Peter Zijlstra, Hugh Dickins, Nick Piggin, Paul Menage
and code contributions and bug fixes from Hugh Dickins, Pavel Emelianov,
Lee Schermerhorn, YAMAMOTO-San, Andrew Morton and KAMEZAWA-San. I
apologize if I missed out any other names or contributions

At the VM-Summit we decided to try the current double LRU approach for
memory control. At this juncture in the space-time continuum, I seek
your support, feedback, comments and help to move the memory controller

-- 
	Thanks,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
