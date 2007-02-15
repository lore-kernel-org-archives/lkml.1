Return-Path: <linux-kernel-owner+w=401wt.eu-S965700AbXBOMB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965700AbXBOMB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 07:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965710AbXBOMB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 07:01:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44904 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965700AbXBOMB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 07:01:58 -0500
Date: Thu, 15 Feb 2007 04:01:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: nigel@nigel.suspend2.net
Cc: Otavio Salvador <otavio@debian.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add PM_TRACE x86_64 support.
Message-Id: <20070215040145.db50ab50.akpm@linux-foundation.org>
In-Reply-To: <1170900487.4451.62.camel@nigel.suspend2.net>
References: <1170895857.4451.55.camel@nigel.suspend2.net>
	<87lkj9bg67.fsf@neumann.lab.ossystems.com.br>
	<1170900487.4451.62.camel@nigel.suspend2.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Feb 2007 13:08:06 +1100 Nigel Cunningham <nigel@nigel.suspend2.net> wrote:

> This patch add x86_64 support for PM_TRACE, and shifts per-arch code to
> the appropriate subdirectories.

ia64 allmodconfig:

include/linux/resume-trace.h:4:30: asm/resume-trace.h: No such file or directory
drivers/base/power/resume.c: In function `resume_device':
drivers/base/power/resume.c:28: warning: implicit declaration of function `TRACE_RESUME'
