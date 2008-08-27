Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbYH0WYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbYH0WYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYH0WYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:24:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58294 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYH0WYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:24:31 -0400
Message-ID: <48B5D3F9.6010308@zytor.com>
Date: Wed, 27 Aug 2008 15:23:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: Re: [patch] xsave: restore xcr0 during resume
References: <20080827215736.GI1152@linux-os.sc.intel.com>
In-Reply-To: <20080827215736.GI1152@linux-os.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> Add the missing XCR0(XFEATURE_ENABLED_MASK) restore during resume.
> 
> Reported-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Applied to tip:x86/xsave, thanks.

	-hpa
