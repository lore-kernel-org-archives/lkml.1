Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZF3Ul5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZF3Ul5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZF3Ult
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:41:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40414 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbZF3Ult (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:41:49 -0400
Date: Tue, 30 Jun 2009 17:41:43 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 0/3] perf_counter tools: filter by comm, dso & symbol
	lists
Message-ID: <20090630204143.GA15682@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	The following patches allows filtering by comm, dso & symbol
lists, in a way similar to oprofile image: parameters.

Regards,

- Arnaldo
