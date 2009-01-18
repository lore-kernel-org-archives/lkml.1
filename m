Return-Path: <linux-kernel-owner+w=401wt.eu-S932637AbZARKEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbZARKEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 05:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760183AbZARKEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 05:04:07 -0500
Received: from bowden.ucwb.org.au ([203.122.237.119]:60623 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbZARKEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 05:04:05 -0500
Subject: Re: [git pull] scheduler fixes
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4972F487.2040002@redhat.com>
References: <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
	 <1232186877.14073.59.camel@laptop>
	 <1232188484.6813.85.camel@marge.simson.net>
	 <1232193617.14073.67.camel@laptop>
	 <1232194752.6273.5.camel@marge.simson.net>
	 <20090117044316.bda7d0bd.akpm@linux-foundation.org>
	 <1232198574.16303.8.camel@marge.simson.net>
	 <20090117160115.GA31601@elte.hu> <4972E860.5080206@redhat.com>
	 <20090118083744.GB21940@elte.hu> <4972EF6B.90207@redhat.com>
	 <4972F487.2040002@redhat.com>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Sun, 18 Jan 2009 20:11:24 +1030
Message-Id: <1232271684.4824.30.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 11:21 +0200, Avi Kivity wrote:
> If the host load is low enough, it may be worthwhile to repeat with 
> -no-kvm.  It's significantly different from kvm (much higher cpu load, 
> and less tasks involved), but if the problem recurs, we know it's a pure 
> sched issue.

Okay, I'll see how I go with this tonight.

Regards,
Kevin.


