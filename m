Return-Path: <linux-kernel-owner+w=401wt.eu-S1763640AbXESGDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763640AbXESGDI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 02:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbXESGC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 02:02:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756400AbXESGC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 02:02:57 -0400
Date: Sat, 19 May 2007 02:02:50 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64 II
Message-ID: <20070519060250.GA20061@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <200705190753.16570.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705190753.16570.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 07:53:16AM +0200, Andi Kleen wrote:

 > This preserves the 6 <= model  <= 9 logic of the C code; this means
 > if VIA ever brings out model >= 10 it hopefully sets this bit by default.
 > Dave, do you have any information to the contrary?

Model 10 (Esther) has the same feature.

	Dave

-- 
http://www.codemonkey.org.uk
