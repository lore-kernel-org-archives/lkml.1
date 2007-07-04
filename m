Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbXGDK7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbXGDK7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbXGDK7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:59:03 -0400
Received: from ozlabs.org ([203.10.76.45]:42472 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756976AbXGDK7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:59:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18059.31464.183382.358931@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jul 2007 20:48:08 +1000
From: Paul Mackerras <paulus@samba.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <200707041233.18199.rjw@sisk.pl>
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707032332.49694.rjw@sisk.pl>
	<18059.5165.861038.392332@cargo.ozlabs.ibm.com>
	<200707041233.18199.rjw@sisk.pl>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki writes:

> So, I gather, you're volunteering to handle suspend-related bug reports
> from the point in which we drop the freezer from the suspend code path?

Ben and I are happy to handle all the ones for the platform we
maintain, which currently does suspend without freezing processes. :)

Paul.
