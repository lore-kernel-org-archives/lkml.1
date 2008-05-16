Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbYEPTrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbYEPTrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbYEPTrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:47:33 -0400
Received: from mga10.intel.com ([192.55.52.92]:54000 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751377AbYEPTrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:47:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,499,1204531200"; 
   d="scan'208";a="329187061"
Message-ID: <482DE4D1.5020608@linux.intel.com>
Date: Fri, 16 May 2008 12:47:29 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap@sources.redhat.com
Subject: Re: notification for systemtap-related oops
References: <482DB93B.2080100@linux.intel.com> <y0mskwif5hm.fsf@ton.toronto.redhat.com>
In-Reply-To: <y0mskwif5hm.fsf@ton.toronto.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Ch. Eigler wrote:
> Hi -
> 
> Arjan, would it be possible for kerneloops.org to notify us systemtap
> people (cc:d) automagically if the oops messages implicate systemtap
> modules by including "stap_.*" in the loaded-module list or stack
> backtrace symbols?

I can get you an RSS feed for that....

doing something more proactive is harder due to the unscalable nature
