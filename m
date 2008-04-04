Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbYDDFUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbYDDFUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 01:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYDDFUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 01:20:38 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:57612 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbYDDFUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 01:20:38 -0400
Date: Fri, 4 Apr 2008 10:50:20 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: INFO: possible circular locking in the resume
Message-ID: <20080404052020.GA7855@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.tGB.hGW9HB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pdYe6zNQVl.A.tGB.hGW9HB@albercik>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 01:22:43AM +0200, Rafael J. Wysocki wrote:
> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10133
> Subject		: INFO: possible circular locking in the resume
> Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Date		: 2008-02-27 (37 days old)
> References	: http://lkml.org/lkml/2008/2/26/479
> Handled-By	: Gautham R Shenoy <ego@in.ibm.com>
> 

Yes it still is present in the mainline.

Sorry, didn't have time to fix it, since I have been busy with other stuff. 
Will have a look at it over the weekend.

-- 
Thanks and Regards
gautham
