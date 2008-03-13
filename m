Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbYCMMdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbYCMMdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYCMMcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:32:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbYCMMcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:32:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080312150042.96668bcd.akpm@linux-foundation.org>
References: <20080312150042.96668bcd.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: pm_register() and pm_send_all()
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 13 Mar 2008 12:31:37 +0000
Message-ID: <21968.1205411497@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> pm_send_all() has just a handful of callers:

What should be done instead of calling pm_send_all()?

David
