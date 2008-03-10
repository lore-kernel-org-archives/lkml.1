Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbYCJKfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbYCJKfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 06:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYCJKfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 06:35:37 -0400
Received: from aun.it.uu.se ([130.238.12.36]:46015 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbYCJKfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 06:35:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18389.3748.687327.166061@harpo.it.uu.se>
Date: Mon, 10 Mar 2008 11:34:12 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc4-git3: Reported regressions from 2.6.24
In-Reply-To: <200803100132.57160.rjw@sisk.pl>
References: <200803100132.57160.rjw@sisk.pl>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki writes:
 > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10209
 > Subject		: 2.6.25 sysdev API problem
 > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
 > Date		: 2008-03-08 16:56
 > References	: http://lkml.org/lkml/2008/3/8/59
 > Handled-By	: Greg KH <gregkh@suse.de>

Patch here: http://lkml.org/lkml/2008/3/9/10
(different thread, alas, hence not linked with the above one)

Confirmed to work. Waiting for Greg's ack/nak.
