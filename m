Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZKRWF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZKRWF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbZKRWF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:05:57 -0500
Received: from mga10.intel.com ([192.55.52.92]:45807 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756887AbZKRWFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:05:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,766,1249282800"; 
   d="scan'208";a="515250668"
Message-ID: <4B046FC8.2040904@linux.intel.com>
Date: Wed, 18 Nov 2009 14:06:00 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Josh Stone <jistone@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tracing: Remove the stale include/trace/power.h
References: <1258578415-14752-1-git-send-email-jistone@redhat.com>
In-Reply-To: <1258578415-14752-1-git-send-email-jistone@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Stone wrote:
> Commit 6161352 moved the power tracing to include/trace/events/, but
> left the old header behind.  No one is using the old header, and its
> declarations are now incorrect, so it should be removed.
> 

hmm I could have sworn my patch did that... it was supposed to

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

/

