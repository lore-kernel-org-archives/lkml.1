Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbYDMTyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbYDMTyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbYDMTso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:48:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:40286 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757220AbYDMTsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:48:43 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18Qw8suVzIQ8wdYFcW9Y0MII/rmCKRRaX5QSdH8vc
	2RSbGSUZ6wPei1
Date: Sun, 13 Apr 2008 21:48:37 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Tracy <rct@frus.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10366] 2.6.25-rc7: warn_on_slowpath triggered
Message-ID: <20080413194837.GA6518@atjola.homenet>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <oq66hWjeF4N.A.Tm.13lAIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <oq66hWjeF4N.A.Tm.13lAIB@albercik>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.04.13 20:56:42 +0200, Rafael J. Wysocki wrote:
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
> Handled-By	: Björn Steinbrink <B.Steinbrink@gmx.de>
> Patch		: http://lkml.org/lkml/2008/3/30/245

Ingo, you have that patch in your tree, are you going to push that to
Linus any time soon (ie. before 2.6.25)?

Thanks,
Björn
