Return-Path: <linux-kernel-owner+w=401wt.eu-S933604AbZLGEJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbZLGEJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 23:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933296AbZLGEJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 23:09:42 -0500
Received: from mail.perches.com ([173.55.12.10]:1081 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933285AbZLGEJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 23:09:42 -0500
Subject: Re: [PATCH 1/6 for 2.6.33] docs: use KERN_WARNING, not KERN_WARN
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Lyon <andrew.lyon@gmail.com>
In-Reply-To: <12601530442994@xenotime.net>
References: <12601530442994@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Dec 2009 20:09:47 -0800
Message-ID: <1260158987.11126.141.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 18:30 -0800, Randy Dunlap wrote:
> Subject: Use KERN_WARNING instead of KERN_WARN, which does not exist

Perhaps it's better to use pr_warning instead.


