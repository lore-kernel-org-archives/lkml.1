Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbZIXSVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbZIXSVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZIXSVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:21:05 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:33542 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbZIXSVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:21:03 -0400
Message-ID: <4ABBB88A.5000200@linux.vnet.ibm.com>
Date: Thu, 24 Sep 2009 23:50:58 +0530
From: Rishikesh <risrajak@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Dan Smith <danms@us.ibm.com>
CC: Oren Laadan <orenl@librato.com>, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
References: <1253749920-18673-1-git-send-email-orenl@librato.com> <4ABB6EB6.2040204@linux.vnet.ibm.com> <878wg41f65.fsf@caffeine.danplanet.com>
In-Reply-To: <878wg41f65.fsf@caffeine.danplanet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Smith wrote:
> R> I am getting following build error while compiling linux-cr kernel.
>
> With CONFIG_CHECKPOINT=n, right?
>
> R> 76569 net/unix/af_unix.c:528: error: ‘unix_collect’ undeclared here (not 
> R> in a function)
>
> Try the patch below.
>   

Yes attached patch solves the prob. Thanks Dan.

