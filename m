Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbYDDANL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbYDDANL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbYDDAHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:07:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34874 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757418AbYDDAHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:07:14 -0400
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Cc: Christoph Lameter <clameter@sgi.com>,
       Toralf Foerster <toralf.foerster@gmx.de>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.kR.5DW9HB@albercik>
Subject: slub compile error
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:22:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10373
Subject		: slub compile error
Submitter	: Toralf Foerster <toralf.foerster@gmx.de>
Date		: 2008-03-31 14:46 (4 days old)
References	: http://lkml.org/lkml/2008/3/31/120
Handled-By	: Christoph Lameter <clameter@sgi.com>
Patch		: http://lkml.org/lkml/2008/3/31/261


