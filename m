Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbYDMWwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbYDMWwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbYDMWwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:52:04 -0400
Received: from cpsmtpo-eml02.kpnxchange.com ([213.75.38.151]:31302 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754314AbYDMWwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:52:02 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10428] [rc8] Regression: key repeats and skips in music during compilation
Date: Mon, 14 Apr 2008 00:51:58 +0200
User-Agent: KMail/1.9.9
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <oq66hWjeF4N.A.9N.N3lAIB@albercik>
In-Reply-To: <oq66hWjeF4N.A.9N.N3lAIB@albercik>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140051.59058.elendil@planet.nl>
X-OriginalArrivalTime: 13 Apr 2008 22:51:59.0577 (UTC) FILETIME=[FB4D9C90:01C89DB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 April 2008, you wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.24.  Please verify if it still should be listed.

Yes. Still being investigated (mostly by private mails).
Change that caused the regression after -rc5 has been located (see bugzilla),
but the real cause appears to be deeper.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10428
> Subject	: [rc8] Regression: key repeats and skips in music during compilation
> Submitter	: Frans Pop <elendil@planet.nl> 
> Date		: 2008-04-04 12:22 (10 days old)
> References	: http://lkml.org/lkml/2008/4/4/83
> Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 		  Ingo Molnar <mingo@elte.hu>
