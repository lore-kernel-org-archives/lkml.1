Return-Path: <linux-kernel-owner+w=401wt.eu-S1760447AbYALWQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbYALWQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 17:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbYALWQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 17:16:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:55049 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbYALWQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 17:16:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lKItoQTwqNkUhvTcBaqNE8plvaOXBpxtUmS/AENX1RShAAJ8r3bQKgz9fEpDDb2a/YPWvVsyhPUtME76Aa5CjohnfqTvTD4IH9m4erf3anA0/dQ07UZ7HajRG3g5PT8QTOYM2GYYhwIPEknWOTBCwNt/IrZJssI+cIJdSIGTsi0=
Subject: Re: 2.6.24-rc7-git4: Reported regressions from 2.6.23
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
In-Reply-To: <200801122205.34871.rjw@sisk.pl>
References: <200801122205.34871.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 12 Jan 2008 14:16:24 -0800
Message-Id: <1200176184.19760.100.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-01-12 at 22:05 +0100, Rafael J. Wysocki wrote:
> [RFC: Would that be useful if I sent regression-fixing patches, CCed to the
> appropriate maintainers/lists, along with the reports?]

Perhaps keep the regression report as-is, but for each regression with
a patch follow up with an appropriately CC'd reply to the regression
report.  Similar in concept to the regression report being patch 0/X
or how the -stable series patches are announced?

Harvey

