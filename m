Return-Path: <linux-kernel-owner+w=401wt.eu-S932410AbYCDQkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbYCDQkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765998AbYCDQgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:36:36 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:47494 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765997AbYCDQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:36:34 -0500
Date: Tue, 4 Mar 2008 08:35:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Bart <bzolnier@gmail.com>
Subject: Re: 2.6.25-rc3-mm1 (IDE)
Message-Id: <20080304083534.c936fe57.randy.dunlap@oracle.com>
In-Reply-To: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 01:19:28 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/

i386 allmodconfig gives me this:

ERROR: "probe_4drives" [drivers/ide/ide-core.ko] undefined!

---
~Randy
