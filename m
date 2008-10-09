Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbYJITV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbYJITV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760617AbYJITVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:21:09 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49951 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760732AbYJITVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:21:07 -0400
Date: Thu, 9 Oct 2008 12:20:57 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, Gary Hade <garyhade@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: [PATCH 0/2] memory section sysfs enhancements
Message-ID: <20081009192057.GA8793@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following two patches are in response to comments received from 
Yasunori Goto on 30 Sept, 2008 with respect to the "mm: show node to memory
section relationship with symlinks in sysfs" patch posted on 29 Sept, 2008.
  http://marc.info/?l=linux-kernel&m=122276241810881&w=2

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
