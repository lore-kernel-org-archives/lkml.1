Return-Path: <linux-kernel-owner+w=401wt.eu-S1762874AbXGEW1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762874AbXGEW1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760419AbXGEW1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:27:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759169AbXGEW1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:27:00 -0400
Date: Thu, 5 Jul 2007 15:26:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, Jordan Crouse <jordan.crouse@amd.com>,
       info-linux@geode.amd.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 1/3] GEODE: basic infrastructure support for AMD
 geode-class machines
Message-Id: <20070705152616.31c7c0d1.akpm@linux-foundation.org>
In-Reply-To: <20070705160251.aea9aedc.dilinger@queued.net>
References: <20070705160251.aea9aedc.dilinger@queued.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The patches have some trivial-but-common coding-style bloopers which
scripts/checkpatch.pl will detect.  Please check it out.

Please send a patch which documents mfgpt_irq in
Documentation/kernel-parameters.txt, thanks.

Andy, the miss rate on documentation for new __setup() handlers is about
75%.  Might be worth adding to checkpatch.pl.
