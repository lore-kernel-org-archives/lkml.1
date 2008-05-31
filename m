Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbYEaUjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbYEaUjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 16:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbYEaUjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 16:39:44 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4587 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbYEaUjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 16:39:44 -0400
Date: Sat, 31 May 2008 20:39:19 +0000
From: thunder7@xs4all.nl
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@medozas.de>, thunder7 <thunder7@xs4all.nl>
Subject: Re: [Bug #10816] vt/fbcon: fix background color on line feed
Message-ID: <20080531203919.GA1449@wl500g>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <UJSav77TyUB.A.ETD.2qZQIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <UJSav77TyUB.A.ETD.2qZQIB@albercik>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Date: Sat, May 31, 2008 at 07:48:06PM +0200
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10816
> Subject		: vt/fbcon: fix background color on line feed
> Submitter	: thunder7 <thunder7@xs4all.nl>
> Date		: 2008-05-27 19:33 (5 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121191733218735&amp;w=4
> Handled-By	: Jan Engelhardt <jengelh@medozas.de>
> Patch		: http://marc.info/?l=linux-kernel&amp;m=121199453010047&amp;w=4
> 
No, this regression should be unlisted, as I've tested this patch and it
fixes the regression.

Kind regards,
Jurriaan
