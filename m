Return-Path: <linux-kernel-owner+w=401wt.eu-S1762065AbYDDAQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762065AbYDDAQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761562AbYDDAOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:14:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35001 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760362AbYDDAOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:14:42 -0400
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
In-Reply-To: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
Cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-ID: <pdYe6zNQVl.A.5H.xDW9HB@albercik>
Subject: 2.6.25-rc6-git2: warn_on_slowpath for tcp_simple_retransmit
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  4 Apr 2008 01:30:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following report is on the current list of known regressions
from 2.6.24.  Please verify if the issue is still present in the
mainline.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10384
Subject		: 2.6.25-rc6-git2: warn_on_slowpath for tcp_simple_retransmit
Submitter	: Alessandro Suardi <alessandro.suardi@gmail.com>
Date		: 2008-04-02 00:28 (2 days old)
References	: http://lkml.org/lkml/2008/4/1/408
Handled-By	: Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>


