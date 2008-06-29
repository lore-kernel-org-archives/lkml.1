Return-Path: <linux-kernel-owner+w=401wt.eu-S1762467AbYF2Ts5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762467AbYF2Ts5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbYF2Tsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:48:45 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:55366 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbYF2Tso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:48:44 -0400
Message-ID: <4867E756.8040802@keyaccess.nl>
Date: Sun, 29 Jun 2008 21:49:42 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: [Bug #10958] LMSENSORS: 2.6.26-rc, enabling ACPI Termal Zone
 support costs sensors
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik> <X8mbwW6K81I.A.C0D.-69ZIB@albercik>
In-Reply-To: <X8mbwW6K81I.A.C0D.-69ZIB@albercik>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 2.0 (++)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29-06-08 20:18, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10958
> Subject	: LMSENSORS: 2.6.26-rc, enabling ACPI Termal Zone support costs sensors
> Submitter	: Rene Herman <rene.herman@keyaccess.nl>
> Date		: 2008-06-22 0:47 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=121409569819064&w=4
> Handled-By	: Hans de Goede <j.w.r.degoede@hhs.nl>
> 		  Rene Herman <rene.herman@keyaccess.nl>
> Patch		: http://lkml.org/lkml/2008/6/22/83

An updated version of the patch as linked to above has been merged to 
the ACPI release branch (for details, see the bugzilla entry) and will 
be pushed to Linus for .26.

Rene.
