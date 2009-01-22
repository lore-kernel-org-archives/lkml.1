Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZAVITT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZAVITT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbZAVITI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:19:08 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:44387 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbZAVITH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:19:07 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
References: <87prihcepl.fsf@burly.wgtn.ondioline.org>
	<200901211713.39630.rjw@sisk.pl>
Date: Thu, 22 Jan 2009 21:19:04 +1300
In-Reply-To: <200901211713.39630.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 21 Jan 2009 17:13:39 +0100")
Message-ID: <87k58nda87.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Wednesday 21 January 2009, Paul Collins wrote:
>> Got a couple of these on a PowerBook running 2.6.29-rc2 either during
>> suspend or resume -- it's hard to tell.  (The suspend message is
>> timestamped in syslog with the time I resumed, so I guess it was
>> buffered along with the subsequent "Badness" messages.)
>
> Please check if the patch from http://lkml.org/lkml/2009/1/13/144 fixes the
> problem for you.

It does not fix the problem.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
