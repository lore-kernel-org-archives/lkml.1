Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbYCNFcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbYCNFcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYCNFcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:32:00 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:60005 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751516AbYCNFcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:32:00 -0400
Message-ID: <47DA0DDB.7010403@davidnewall.com>
Date: Fri, 14 Mar 2008 16:02:11 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] PM: Remove legacy PM
References: <200803132351.19794.rjw@sisk.pl>
In-Reply-To: <200803132351.19794.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> The first of the following two patches removes the legacy PM infrastructure
> and the second one removes some of its remnants from the MIPS tree.

What does "legacy PM" mean?  Is it APM, which most assuredly needs to
remain?
