Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbXFWSvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbXFWSvX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 14:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbXFWSvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 14:51:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbXFWSvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 14:51:12 -0400
Date: Sat, 23 Jun 2007 11:50:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Wang Zhenyu <zhenyu.z.wang@intel.com>, carlo@alinoe.com,
       linux-kernel@vger.kernel.org, eric@anholt.net
Subject: Re: [PATCH][AGPGART] intel_agp: don't load if no IGD and AGP port
Message-Id: <20070623115049.248ff86e.akpm@linux-foundation.org>
In-Reply-To: <20070623184221.GB18605@redhat.com>
References: <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org>
	<20070618225009.GE13538@alinoe.com>
	<alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org>
	<20070619233716.GA5779@alinoe.com>
	<20070620011521.GB2856@zhen-devel.sh.intel.com>
	<20070620014227.GA4090@zhen-devel.sh.intel.com>
	<20070620140237.GB5524@alinoe.com>
	<20070620154610.GA2802@localhost.localdomain>
	<20070621054318.GA31381@zhen-devel.sh.intel.com>
	<20070623095203.66bb8572.akpm@linux-foundation.org>
	<20070623184221.GB18605@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 14:42:21 -0400 Dave Jones <davej@redhat.com> wrote:

>  > I probably _could_ work this out, and kinda did with a bit of list-trolling
>  > (verdict: needed in 2.6.22) but please, take care to describe the
>  > importance of a patch in the changelog?
> 
> This got merged a day or two ago.

OK.  -stable didn't appear to get a copy though?
