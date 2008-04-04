Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYDDPOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYDDPOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYDDPOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 11:14:10 -0400
Received: from ns.unixsol.org ([193.110.159.2]:39253 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYDDPOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 11:14:09 -0400
Message-ID: <47F645BF.4010901@unixsol.org>
Date: Fri, 04 Apr 2008 18:14:07 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
Organization: Unix Solutions Ltd. (http://unixsol.org)
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc6: WARNING: at net/ipv4/tcp_input.c:2510
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.nf.JEW9HB@albercik>
In-Reply-To: <pdYe6zNQVl.A.nf.JEW9HB@albercik>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around 04/04/08 02:22, Rafael J. Wysocki scribbled:
> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10346
> Subject		: Linux 2.6.25-rc6: WARNING: at net/ipv4/tcp_input.c:2510
> Submitter	: Georgi Chorbadzhiyski <gf@unixsol.org>
> Date		: 2008-03-27 17:29 (8 days old)
> References	: http://lkml.org/lkml/2008/3/27/246

Upgraded to 2.6.25-rc8-00139-ge315c12, the server is running 8 hours
already and it seems it's fixed.

Anyway, should such warnings be threated as regressions?

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/
