Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbZKHRCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbZKHRCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbZKHRCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:02:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50251 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbZKHRCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:02:09 -0500
Date: Sun, 8 Nov 2009 18:02:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Clark Williams <williams@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: perf tools: modify perf routines to use new debugfs routines
Message-ID: <20091108170204.GB5440@elte.hu>
References: <20091108090307.0fa25a18@torg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108090307.0fa25a18@torg>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


was because the patch did not contain any Makefile modifications to link 
in the new object file.

I fixed that, the two patches work fine now.

	Ingo
