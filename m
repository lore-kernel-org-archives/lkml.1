Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333Ab0A1GXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab0A1GXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 01:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884Ab0A1GXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 01:23:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:34557 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab0A1GXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 01:23:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FoMJE9Yb/y45c7seEiagBbQkleJR0DiMQ3vQW9TpuCdE5+XVcmIag8F4LeMfI/UCcE
         06S4B98oCi8fPcYmcEeTeSEDzDUfoP2EidDHPZoTOFor4aBUQSGv6Qbd509Z/9Uo3HJe
         qjLPC55/wlGe7zvFwH10u1sD6nE1cE693WVgM=
Message-ID: <4B612D57.4080604@gmail.com>
Date: Thu, 28 Jan 2010 07:23:19 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] core: posix-cpu-timers, cleanup rlimits usage
References: <1264610071-24794-1-git-send-email-jslaby@suse.cz> <20100127171335.7edf041d.akpm@linux-foundation.org>
In-Reply-To: <20100127171335.7edf041d.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2010 02:13 AM, Andrew Morton wrote:
> posix-timersc-dont-export-local-functions.patch
> cpu-timers-simplify-rlimit_cpu-handling.patch
> cpu-timers-cleanup-arm_timer.patch
> cpu-timers-return-correct-previous-timer-reload-value.patch
> cpu-timers-change-sigev_none-timer-implementation.patch
> cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
> cpu-timers-optimize-run_posix_cpu_timers.patch

I don't have these in the current mmotm.

> (The above patches are up to six months old.  Something isn't working right).

Could you submit a new mmotm, please?

-- 
js
