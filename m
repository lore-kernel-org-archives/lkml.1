Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbYDDAHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbYDDAHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbYDDAHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:07:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34870 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbYDDAHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:07:05 -0400
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Cc: Soeren Sonnenburg <kernel@nn7.de>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.oJB.pGW9HB@albercik>
Subject: 2.6.25-current-git hangs on boot (pci=nommconf helps)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:22:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10117
Subject		: 2.6.25-current-git hangs on boot (pci=nommconf helps)
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-02-23 18:55 (41 days old)
References	: http://lkml.org/lkml/2008/2/23/263


