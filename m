Return-Path: <linux-kernel-owner+w=401wt.eu-S1762226AbYERMYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762226AbYERMYK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759579AbYERMNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:13:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58373 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758558AbYERMNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:13:34 -0400
Cc: "Jiri Slaby" <jirislaby@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Sam Ravnborg" <sam@uranus.ravnborg.org>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
In-Reply-To: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7wuznNhcUqC.A.-CH.zrBMIB@albercik>
Subject: [Bug #10717] crossbuild fails in modpost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 18 May 2008 13:13:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10717
Subject		: crossbuild fails in modpost
Submitter	: Jiri Slaby <jirislaby@gmail.com>
Date		: 2008-05-15 13:44 (4 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121085909512097&amp;w=4
Handled-By	: Sam Ravnborg <sam@ravnborg.org>


