Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbXLNS6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbXLNS6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbXLNS6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:58:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbXLNS6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:58:11 -0500
Date: Fri, 14 Dec 2007 13:58:02 -0500
From: Dave Jones <davej@redhat.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation>, protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
Message-ID: <20071214185802.GA21306@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation>, protasnb@gmail.com
References: <4762CF8C.90808@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4762CF8C.90808@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 10:46:36AM -0800, Arjan van de Ven wrote:
 > The http://www.kerneloops.org website collects kernel oops and warning reports from various mailing lists and bugzillas; below is a top 10 
 > list of the oopses collected in the last 7 days. (Reports prior to 2.6.23 have been omitted in collecting the top 10)
 > 
 > This is the first such report that I'm posting; Please let me know if this is useful or not.

I like!   Good work.

 > cpufreq_remove_dev crash
 > 	BUG at drivers/cpufreq/cpufreq.c:1060
 > 	2 times last week
 > 	Has been reported only for 2.6.24-rc4
 > 	More Info: http://www.kerneloops.org/search.php?search=cpufreq_remove_dev
 > 	More Info: http://www.kerneloops.org/oops.php?number=2458

Patch pending.  Already in -mm. Also sitting in Linus' inbox. 

	Dave

-- 
http://www.codemonkey.org.uk
