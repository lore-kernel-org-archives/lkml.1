Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbXC0UvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbXC0UvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXC0UvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:51:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56489 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbXC0UvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:51:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Marcus Better <marcus@better.se>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [4/5] 2.6.21-rc5: known regressions
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	<200703271000.05341.marcus@better.se>
	<m13b3qzumf.fsf@ebiederm.dsl.xmission.com>
	<200703271853.43764.marcus@better.se>
Date: Tue, 27 Mar 2007 14:50:57 -0600
In-Reply-To: <200703271853.43764.marcus@better.se> (Marcus Better's message of
	"Tue, 27 Mar 2007 18:53:40 +0200")
Message-ID: <m1tzw6wgum.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcus Better <marcus@better.se> writes:

> Eric W. Biederman wrote:
>
>> >> Patch      : http://lkml.org/lkml/2007/3/24/136
>
>> Marcus any chance I could see an oops?
>
> I didn't see anything, it froze with the yellow "Linux!" sign. Any idea how to 
> get a oops?
>
>> Or you could try the patch I 
>> previously posted when debugging this with Thomas.
>
> Do you mean the one referenced above? I tried it [1] and it works.

Yes.  Sorry for being redundant. Having the bisect results after the
confirmation that the patch worked threw me.

Eric
