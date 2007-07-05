Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbXGEQG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbXGEQG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbXGEQGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:06:22 -0400
Received: from sccrmhc15.comcast.net ([63.240.77.85]:53042 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171AbXGEQGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:06:21 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oliver@neukum.org>,
       Miklos Szeredi <miklos@szeredi.hu>, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, benh@kernel.crashing.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <20070705142318.GA22598@srcf.ucam.org> (Matthew Garrett's message
	of "Thu\, 5 Jul 2007 15\:23\:18 +0100")
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com>
	<200707051528.34754.oliver@neukum.org>
	<20070705134632.GA22177@srcf.ucam.org> <200707051609.25887.rjw@sisk.pl>
	<20070705142318.GA22598@srcf.ucam.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Thu, 05 Jul 2007 12:06:09 -0400
Message-ID: <87wsxeu972.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Thu, Jul 05, 2007 at 04:09:24PM +0200, Rafael J. Wysocki wrote:
>> On Thursday, 5 July 2007 15:46, Matthew Garrett wrote:
>> > I have a model for STD that avoids the need to freeze the entirity of 
>> > userspace, but I need to find some more time to flesh it out.
>> 
>> You can just describe it, as far as I'm concerned. :-)

[snip: new hibernate idea]

I think my kexec-based hibernate idea is simpler and more feasible than
this approach, and also avoids the freezer.

-- 
Jeremy Maitin-Shepard
