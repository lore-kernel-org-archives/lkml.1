Return-Path: <linux-kernel-owner+w=401wt.eu-S1030456AbXDKWHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030456AbXDKWHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030459AbXDKWHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:07:00 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34338 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030456AbXDKWG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:06:59 -0400
Date: Wed, 11 Apr 2007 15:06:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch] uninline remove/add_parent() APIs
Message-Id: <20070411150614.bfaa4ae0.akpm@linux-foundation.org>
In-Reply-To: <m1ps6btmym.fsf@ebiederm.dsl.xmission.com>
References: <20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru>
	<20070406173249.GA2517@elte.hu>
	<m11wix73ut.fsf@ebiederm.dsl.xmission.com>
	<20070410134814.GA28016@elte.hu>
	<m17iskz3i8.fsf@ebiederm.dsl.xmission.com>
	<20070410150650.GA9946@elte.hu>
	<m1tzvoxniv.fsf@ebiederm.dsl.xmission.com>
	<20070410155314.GA16267@elte.hu>
	<20070411062041.GA8017@elte.hu>
	<m1ps6btmym.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 01:00:17 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Should we copy Andrew or is someone else going to collect up all of these patches?

Andrew is cowering in terror, because utrace goes tromping through this
code.

It would be rather good to get utrace moving along a bit more quickly.  There
still seem to be rather a lot of issues.
