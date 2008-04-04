Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbYDDOL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbYDDOL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbYDDOLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:11:48 -0400
Received: from rtr.ca ([76.10.145.34]:1943 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712AbYDDOLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:11:33 -0400
Message-ID: <47F63713.7010301@rtr.ca>
Date: Fri, 04 Apr 2008 10:11:31 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc7/8: Another resume regression
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.e5H.pDW9HB@albercik>
In-Reply-To: <pdYe6zNQVl.A.e5H.pDW9HB@albercik>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10391
> Subject		: 2.6.25-rc7/8: Another resume regression
> Submitter	: Mark Lord <lkml@rtr.ca>
> Date		: 2008-04-03 15:06 (1 days old)
> References	: http://lkml.org/lkml/2008/4/3/283
..

Probably still there, but it's not easily reproduceable
and doesn't happen more than once every couple of days or so.

-ml
 

