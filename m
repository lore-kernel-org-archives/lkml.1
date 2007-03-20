Return-Path: <linux-kernel-owner+w=401wt.eu-S933928AbXCTPco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928AbXCTPco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933909AbXCTPco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:32:44 -0400
Received: from tapsys.com ([72.36.178.242]:35762 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933943AbXCTPcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:32:42 -0400
Message-ID: <45FFFE89.5050801@madrabbit.org>
Date: Tue, 20 Mar 2007 08:32:25 -0700
From: Ray Lee <ray-lk@madrabbit.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [2/6] 2.6.21-rc4: known regressions
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184915.GV752@stusta.de>
In-Reply-To: <20070318184915.GV752@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This email lists some known regressions in Linus' tree compared to 2.6.20.
[...]
> Subject    : ACPI regression with noapic
> References : http://lkml.org/lkml/2007/3/8/468
> Submitter  : Ray Lee <ray-lk@madrabbit.org>
> Status     : unknown

I finally have time to start bisecting this. I'll have something in the
next day.

Ray
