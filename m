Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYDDGcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYDDGcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 02:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYDDGc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 02:32:27 -0400
Received: from nn7.de ([85.214.94.156]:49787 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbYDDGc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 02:32:27 -0400
Subject: Re: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n -
	Apple
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pallipadi@ogre.sisk.pl, Venkatesh <venkatesh.pallipadi@intel.com>
In-Reply-To: <pdYe6zNQVl.A.AOB.6GW9HB@albercik>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <pdYe6zNQVl.A.AOB.6GW9HB@albercik>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 04 Apr 2008 08:32:24 +0200
Message-Id: <1207290744.4511.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-04 at 01:22 +0200, Rafael J. Wysocki wrote:
> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10093
> Subject		: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n - Apple
> Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> Date		: 2008-02-23 18:55 (41 days old)
> References	: http://lkml.org/lkml/2008/2/23/263
> 		  http://marc.info/?l=linux-acpi&m=120387537018467&w=4
> Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>

yes still there, but not a hangs forever hang anymore but only a hang
for (this time) 15 seconds hang.

Soeren
