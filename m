Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbYBLHNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbYBLHNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758634AbYBLHNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:13:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756750AbYBLHNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:13:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc1, weird build error
In-Reply-To: Ingo Molnar's message of  Tuesday, 12 February 2008 08:04:48 +0100 <20080212070448.GA20033@elte.hu>
References: <20080212070448.GA20033@elte.hu>
X-Windows: you'd better sit down.
Message-Id: <20080212071229.6FD95270192@magilla.localdomain>
Date: Mon, 11 Feb 2008 23:12:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   LD      init/built-in.o
> distcc[12023] ERROR: compile (null) on localhost failed
> make: *** [vmlinux.o] Error 1

That message sure looks to me like it could only be a distcc bug.
