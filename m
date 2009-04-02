Return-Path: <linux-kernel-owner+w=401wt.eu-S1765954AbZDBTW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765954AbZDBTW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZDBTWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:22:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39978 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbZDBTWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:22:20 -0400
Date: Thu, 2 Apr 2009 21:22:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: markus.t.metzger@intel.com
Cc: tglx@linutronix.de, hpa@zytor.com, markus.t.metzger@gmail.com,
       roland@redhat.com, eranian@googlemail.com, oleg@redhat.com,
       juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/18] x86, bts, ptrace, hw-branch-tracer: fixes and
	cleanups
Message-ID: <20090402192208.GC2455@elte.hu>
References: <20090402145455.597376000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402145455.597376000@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., the general structure looks good so barring those details i 
pointed out this seems to be the way to go.

	Ingo
