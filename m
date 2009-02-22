Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbZBVL7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbZBVL7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 06:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZBVL7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 06:59:04 -0500
Received: from mga06.intel.com ([134.134.136.21]:62850 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753471AbZBVL7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 06:59:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,249,1233561600"; 
   d="scan'208";a="388803044"
Message-ID: <49A13E16.5030401@linux.intel.com>
Date: Sun, 22 Feb 2009 12:59:18 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: hpa@zytor.com, mingo@redhat.com, torvalds@linux-foundation.org,
       ak@linux.intel.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, mce: remove incorrect __cpuinit for mce_cpu_features()
References: <tip-cc3ca22063784076bd240fda87217387a8f2ae92@kernel.org>
In-Reply-To: <tip-cc3ca22063784076bd240fda87217387a8f2ae92@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Author:     H. Peter Anvin <hpa@zytor.com>
> AuthorDate: Fri, 20 Feb 2009 23:35:51 -0800
> Commit:     H. Peter Anvin <hpa@zytor.com>
> CommitDate: Fri, 20 Feb 2009 23:40:40 -0800
> 
> x86, mce: remove incorrect __cpuinit for mce_cpu_features()
> 
> Impact: Bug fix on UP

Thanks!

> Remove the offending __cpuinit annotations for mce_cpu_features() and
> its successor functions.
> 
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

Acked-by: Andi Kleen <ak@linux.intel.com>


-Andi
