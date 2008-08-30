Return-Path: <linux-kernel-owner+w=401wt.eu-S1761746AbYH3Vl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761746AbYH3Vl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759793AbYH3Vgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:36:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58017 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760213AbYH3Vgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:36:52 -0400
Subject: Re: [Bug #11438] Upcoming oops in lockdep
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <N8SeMoDzuxC.A.C9D.FibuIB@albercik>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
	 <N8SeMoDzuxC.A.C9D.FibuIB@albercik>
Content-Type: text/plain
Date: Sat, 30 Aug 2008 23:36:45 +0200
Message-Id: <1220132205.8426.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-30 at 21:50 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11438
> Subject		: Upcoming oops in lockdep
> Submitter	: Arjan van de Ven <arjan@infradead.org>
> Date		: 2008-08-23 20:49 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=121952463613140&w=4
> 		  http://www.kerneloops.org/searchweek.php?search=mark_lock
> Handled-By	: Peter Zijlstra <peterz@infradead.org>

as far as I'm concerned this has nothing to do with lockdep


