Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbZF3WB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbZF3WB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbZF3WB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:01:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56213 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbZF3WB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:01:28 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] perf_counter tools: filter by comm, dso & symbol lists Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 30 Jun 2009 19:01:19 -0300
Message-Id: <1246399282-20934-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
X-Url: http://oops.ghostprotocols.net:81/blog
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	The following patches allows filtering by comm, dso & symbol
lists, in a way similar to oprofile image: parameters.

Regards,

- Arnaldo
