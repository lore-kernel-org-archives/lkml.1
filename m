Return-Path: <linux-kernel-owner+w=401wt.eu-S1751457AbYHLFFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbYHLFFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 01:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYHLFFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 01:05:22 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:34585 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYHLFFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 01:05:21 -0400
Message-ID: <48A119FA.6070105@linux.vnet.ibm.com>
Date: Tue, 12 Aug 2008 10:34:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       nishimura@mxp.nes.nec.co.jp, xemul@openvz.org, hugh@veritas.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 1/2] mm owner fix race between swap and exit
References: <20080811100719.26336.98302.sendpatchset@balbir-laptop> <20080811100733.26336.31346.sendpatchset@balbir-laptop> <20080811173138.71f5bbe4.akpm@linux-foundation.org> <48A10C4C.6020009@linux.vnet.ibm.com> <20080811215633.f8f5406d.akpm@linux-foundation.org>
In-Reply-To: <20080811215633.f8f5406d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> OK, I'll move it into the general MM patchpile for 2.6.28.  It will precede
> any memrlimit merge.

Thanks, sounds good.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
