Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbYDDAJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbYDDAJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbYDDAHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:07:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbYDDAHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:07:09 -0400
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Cc: Andre Tomt <andre@tomt.net>,
       Matthew Ranostay <mranostay@embeddedalley.com>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.Cu.0EW9HB@albercik>
Subject: 2.6.25-git regression with snd-hda-intel on Dell XPS M1330, no analog sound
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:22:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10302
Subject		: 2.6.25-git regression with snd-hda-intel on Dell XPS M1330, no analog sound
Submitter	: Andre Tomt <andre@tomt.net>
Date		: 2008-03-21 20:03 (14 days old)
References	: http://lkml.org/lkml/2008/3/21/295
Handled-By	: Matthew Ranostay <mranostay@embeddedalley.com>


