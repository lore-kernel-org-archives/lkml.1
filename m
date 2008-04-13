Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYDMUP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYDMUP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbYDMUPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:15:20 -0400
Received: from gherkin.frus.com ([192.158.254.49]:39519 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbYDMUPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:15:20 -0400
Subject: Re: [Bug #10366] 2.6.25-rc7: warn_on_slowpath triggered
In-Reply-To: <oq66hWjeF4N.A.Tm.13lAIB@albercik> "from Rafael J. Wysocki at Apr
 13, 2008 08:56:42 pm"
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sun, 13 Apr 2008 15:15:17 -0500 (CDT)
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?UTF-8?Q?Bj=C3=B6rn_Steinbrink?= <B.Steinbrink@gmx.de>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080413201517.A44D6DBA4@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.24.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10366
> Subject		: 2.6.25-rc7: warn_on_slowpath triggered
> Submitter	: Bob Tracy <rct@frus.com>
> Date		: 2008-03-29 17:29 (16 days old)
> References	: http://lkml.org/lkml/2008/3/29/125
> Handled-By	: Bj?rn Steinbrink <B.Steinbrink@gmx.de>
> Patch		: http://lkml.org/lkml/2008/3/30/245

Patch verified to work on -rc8 and -rc9.  Did not test on -rc7.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
