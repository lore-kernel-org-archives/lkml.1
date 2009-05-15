Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbZEOVjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbZEOVjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbZEOVjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:39:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:54549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbZEOVjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:39:12 -0400
Message-ID: <4A0DE0ED.6090402@kernel.org>
Date: Fri, 15 May 2009 14:38:53 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: tip: patches in git for irq and numa
References: <4A05269D.8000701@kernel.org> <20090511095022.GA23121@elte.hu> <20090511163158.c4e4d334.akpm@linux-foundation.org> <20090512090704.GC18004@elte.hu> <4A0A6700.3070100@kernel.org> <20090513133635.GB7384@elte.hu> <4A0AFA6E.5050200@kernel.org> <20090515173521.GA29647@elte.hu>
In-Reply-To: <20090515173521.GA29647@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq related:
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git irq
need to on top of tip/irq/numa

for memoryless node support: 
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git numa
and it is on top of tip/master

YH

