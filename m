Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbZIGQol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbZIGQol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 12:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZIGQol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 12:44:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33620 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbZIGQok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 12:44:40 -0400
Subject: Re: [PATCH 4/6] perf_counter: Add PERF_COUNTER_IOC_SET_FILTER ioctl
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AA4C0B3.3070300@cn.fujitsu.com>
References: <4AA4C04D.1050201@cn.fujitsu.com>
	 <4AA4C0B3.3070300@cn.fujitsu.com>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 18:44:31 +0200
Message-Id: <1252341871.7959.37.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 16:13 +0800, Li Zefan wrote:
> Allow to set profile filter via ioctl.

Hrm,.. not at all sure about this.. what are the ABI implications?

