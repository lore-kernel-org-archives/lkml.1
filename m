Return-Path: <linux-kernel-owner+w=401wt.eu-S1161169AbXBUJ5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161169AbXBUJ5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 04:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161171AbXBUJ5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 04:57:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161169AbXBUJ5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 04:57:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
X-Fcc: ~/Mail/utrace
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] include/linux/ptrace.h must #include <linux/errno.h>
In-Reply-To: Adrian Bunk's message of  Tuesday, 20 February 2007 01:08:20 +0100 <20070220000820.GN13958@stusta.de>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070221095733.89DCC1800E4@magilla.sf.frob.com>
Date: Wed, 21 Feb 2007 01:57:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the fix.
