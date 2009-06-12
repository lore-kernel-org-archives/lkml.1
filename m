Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbZFLFOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbZFLFOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 01:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZFLFOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 01:14:36 -0400
Received: from tundra.namei.org ([65.99.196.166]:32836 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbZFLFOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 01:14:35 -0400
Date: Fri, 12 Jun 2009 15:12:59 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Joseph Cihula <joseph.cihula@intel.com>, Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com, hpa@zytor.com,
       andi@firstfloor.org, Chris Wright <chrisw@sous-sol.org>,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: Re: [RFC v4][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
 support
In-Reply-To: <4A299051.40405@intel.com>
Message-ID: <alpine.LRH.2.00.0906121509001.14633@tundra.namei.org>
References: <4A299051.40405@intel.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009, Joseph Cihula wrote:

> Linux support for Intel(R) Trusted Execution Technology.

> Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>
> Signed-off-by:  Shane Wang <shane.wang@intel.com>
> Signed-off-by:  Gang Wei <gang.wei@intel.com>

Reviewed-by: James Morris <jmorris@namei.org>

There have been no comments on this since you posted it, so we might 
assume there are no further technical issues.

Ingo, this should probably be merged via your tree.


- James
-- 
James Morris
<jmorris@namei.org>
