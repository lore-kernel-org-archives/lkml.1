Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbXEQJaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbXEQJaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXEQJaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:30:05 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4956 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbXEQJaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:30:04 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 05:30:04 EDT
Message-ID: <464C1EDD.3030008@xs4all.nl>
Date: Thu, 17 May 2007 11:22:37 +0200
From: Hans de Bruin <bruinjm@xs4all.nl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
References: <464B9D2C.7040704@cv-sv.de>
In-Reply-To: <464B9D2C.7040704@cv-sv.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian wrote:
> Hi,
> 
> my small VIA C3_2 box does not boot with 2.6.22-rc1.
> It even does not uncompress the kernel.
> 
> The configuration as M386 M486 works. But M586 + MVIAC3_2
> does not work.

My VIA C7 has the same problem, boots on 486 but not on C3-2 or C7

-- 
Hans


