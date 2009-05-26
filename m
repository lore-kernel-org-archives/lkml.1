Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbZEZNg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbZEZNg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZEZNgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:36:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33395 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbZEZNgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:36:51 -0400
Date: Tue, 26 May 2009 21:30:50 +0800
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix build warning and avoid checking for mem != null
	twice
Message-ID: <20090526133050.GS4858@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <200905261844.33864.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200905261844.33864.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nikanth Karthikesan <knikanth@suse.de> [2009-05-26 18:44:32]:

> Fix build warning, "mem_cgroup_is_obsolete defined but not used" when
> CONFIG_DEBUG_VM is not set. Also avoid checking for !mem twice.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

I thought we fixed this, could you check the latest mmotm please!
-- 
	Balbir
