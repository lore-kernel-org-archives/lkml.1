Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYDII7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYDII7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYDII7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:59:36 -0400
Received: from nn7.de ([85.214.94.156]:49551 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbYDII7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:59:35 -0400
Subject: Re: [Bug #10093] 2.6.25-current-git blocks for 10-15 secs on boot
	unless CONFIG_CPU_IDLE=n - Apple
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <SvnMeM-aZi.A.e3F.yBA_HB@albercik>
References: <SvnMeM-aZi.A.e3F.yBA_HB@albercik>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Apr 2008 10:59:30 +0200
Message-Id: <1207731570.9487.49.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-09 at 01:02 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.24.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10093
> Subject		: 2.6.25-current-git blocks for 10-15 secs on boot unless CONFIG_CPU_IDLE=n - Apple
> Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> Date		: 2008-02-23 18:55 (46 days old)
> References	: http://lkml.org/lkml/2008/2/23/263
> 		  http://marc.info/?l=linux-acpi&m=120387537018467&w=4
> 		  http://lkml.org/lkml/2008/4/5/34
> Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> Patch		: http://marc.info/?l=linux-kernel&m=120674502201007&w=4

It is much better (fixed?) with the patches from Venkatesh, though I
still have to try his latest...

Soeren
