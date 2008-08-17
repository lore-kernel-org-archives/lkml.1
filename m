Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYHQIIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYHQIIB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 04:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYHQIHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 04:07:46 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:59963 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYHQIHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 04:07:45 -0400
Subject: Re: [Bug #11209] 2.6.27-rc1 process time accounting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>
In-Reply-To: <sNRO-BDDjQL.A.2MH.lczpIB@albercik>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
	 <sNRO-BDDjQL.A.2MH.lczpIB@albercik>
Content-Type: text/plain
Date: Sun, 17 Aug 2008 10:07:48 +0200
Message-Id: <1218960468.10800.257.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-16 at 21:02 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11209
> Subject		: 2.6.27-rc1 process time accounting
> Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
> Date		: 2008-07-31 10:43 (17 days old)
> References	: http://marc.info/?l=linux-kernel&m=121750102917490&w=4
> Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Should be fixed by: e26b33e9552c29c1d3fe67dc602c6264c29f5dc7

