Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbYGaQxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbYGaQxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYGaQw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:52:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126AbYGaQwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:52:55 -0400
Date: Thu, 31 Jul 2008 09:52:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [RESEND x9+ patch 2.6.26-git 1/2] lm75: cleanup
 and reorg
Message-Id: <20080731095230.62b6d988.akpm@linux-foundation.org>
In-Reply-To: <489194DC.4020000@hhs.nl>
References: <200807251523.28242.david-b@pacbell.net>
	<20080729233231.0ced6d9b.akpm@linux-foundation.org>
	<48901BF7.9050601@hhs.nl>
	<20080730004615.f0686916.akpm@linux-foundation.org>
	<489194DC.4020000@hhs.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 12:33:00 +0200 Hans de Goede <j.w.r.degoede@hhs.nl> wrote:

> Then there also are 2 new hwmon drivers which really have been waiting to long 
> to get into the kernel too. I'll try to review those too, but I can test only 
> one of them. Let me know if not being able to test the other is a problem for 
> upstream inclusion.

Well, I assume that the original author runtime-tested the code.  It is rare
that a reviewer can runtime test a new driver, and rarer indeed that a
reviewer will actually do so.  So please send them out when ready.
