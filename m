Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbYJIUqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbYJIUqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 16:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYJIUqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 16:46:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39444 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbYJIUqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 16:46:36 -0400
Message-ID: <48EE6D8B.4060602@zytor.com>
Date: Thu, 09 Oct 2008 13:46:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/tip: AMDC1E and XTOPOLOGY conflict in cpufeature
References: <20081007203311.GA31189@linux-os.sc.intel.com>
In-Reply-To: <20081007203311.GA31189@linux-os.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
> Fix two features from conflicting in feature bits. Looks like the conflict
> came from automatic conflict resolution?
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Applied to x86/cpu, thanks!

	-hpa
