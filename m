Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbYDDAK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbYDDAK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758026AbYDDAHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:07:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34874 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755551AbYDDAHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:07:11 -0400
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Cc: Marcus Better <marcus@better.se>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.Wo.lEW9HB@albercik>
Subject: rt2x00 does not associate or give scan results
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:22:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10320
Subject		: rt2x00 does not associate or give scan results
Submitter	: Marcus Better <marcus@better.se>
Date		: 2008-03-25 06:04 (10 days old)


