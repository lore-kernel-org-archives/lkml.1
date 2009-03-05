Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbZCETOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbZCETOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbZCETOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:14:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756640AbZCETOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:14:24 -0500
Date: Thu, 5 Mar 2009 11:13:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: h.rohit@samsung.com, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Artem.Bityutskiy@nokia.com
Subject: Re: [PATCH 1/3] [MTD] Flex-OneNAND support
Message-Id: <20090305111324.1344606e.akpm@linux-foundation.org>
In-Reply-To: <49AFD5EA.5010502@nokia.com>
References: <20090303063605.GA30258@july>
	<20090303124948.dda294e5.akpm@linux-foundation.org>
	<49AE6907.1080702@nokia.com>
	<20090304085055.c9de6cbb.akpm@linux-foundation.org>
	<49AFD5EA.5010502@nokia.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Mar 2009 15:38:50 +0200
Adrian Hunter <adrian.hunter@nokia.com> wrote:

> Can you point me to where EUCLEAN is returned to userspace?

err, nope.  I was googling "euclean" and came across a report where
someone was wondering why he got this errno.  I can't find it now.
