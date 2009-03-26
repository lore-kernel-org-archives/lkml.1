Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbZCZJfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbZCZJfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZCZJf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:35:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:18710 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbZCZJf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:35:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,425,1233561600"; 
   d="scan'208";a="397694324"
Message-ID: <49CB4C7B.8080401@linux.intel.com>
Date: Thu, 26 Mar 2009 10:35:55 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 2/3] x86, mce: Cleanup param parser
References: <49CB3F38.7090703@jp.fujitsu.com>
In-Reply-To: <49CB3F38.7090703@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> - Fix the comment formatting.
> - The error path does not return 0, and printk lacks level and "\n".
> - Move __setup("nomce") next to mcheck_disable().
> - Improve readability etc.

Looks good.

-Andi
