Return-Path: <linux-kernel-owner+w=401wt.eu-S1762038AbXGJSoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038AbXGJSoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbXGJSor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:44:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXGJSop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:44:45 -0400
Date: Tue, 10 Jul 2007 14:44:11 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: agp / cpufreq.
Message-ID: <20070710184411.GA18321@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 01:31:52AM -0700, Andrew Morton wrote:

 > working-3d-dri-intel-agpko-resume-for-i815-chip.patch
 > 
 >  Sent to davej

You managed to sneak this to me just hours before I handed
AGP maintainership to Dave Airlie.  FWIW, I think this needs
to redone in a much more generic manner before it goes mainline.

 > bugfix-cpufreq-in-combination-with-performance-governor.patch
 > restore-previously-used-governor-on-a-hot-replugged-cpu.patch
 > 
 >  Sent to davej

Will start merging the backlog once someone (ahem) pulls
the last lot of stuff.

	Dave

-- 
http://www.codemonkey.org.uk
