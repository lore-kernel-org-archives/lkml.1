Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbYDNHQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbYDNHQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbYDNHP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:15:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47733 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbYDNHPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:15:55 -0400
Date: Mon, 14 Apr 2008 09:15:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10427] e1000e broke e1000
Message-ID: <20080414071546.GD16163@elte.hu>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <oq66hWjeF4N.A.VR.Q3lAIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <oq66hWjeF4N.A.VR.Q3lAIB@albercik>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions 
> from 2.6.24.  Please verify if it still should be listed.

yes, it still occurs.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10427
> Subject		: e1000e broke e1000
> Submitter	: Ingo Molnar <mingo@elte.hu>
> Date		: 2008-04-08 20:39 (6 days old)
> References	: http://lkml.org/lkml/2008/4/8/256
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15704&amp;action=view
