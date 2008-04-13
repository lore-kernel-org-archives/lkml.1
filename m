Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYDMTuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYDMTuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbYDMTo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:44:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36980 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188AbYDMToq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:44:46 -0400
Cc: "David S. Miller" <davem@davemloft.net>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       =?utf-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Jeff Garzik" <jeff@garzik.org>, "Mark Lord" <lkml@rtr.ca>,
       "Pavel Emelyanov" <xemul@openvz.org>,
       =?utf-8?q?YOSHIFUJI=20Hideaki=20/=20=E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E?= 
	<yoshfuji@linux-ipv6.org>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
In-Reply-To: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oq66hWjeF4N.A.yJ.L3lAIB@albercik>
Subject: [Bug #10434] 2.6.25-rc8: FTP transfer errors
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Apr 2008 20:56:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10434
Subject		: 2.6.25-rc8: FTP transfer errors
Submitter	: Mark Lord <lkml@rtr.ca>
Date		: 2008-04-09 00:56 (5 days old)
References	: http://lkml.org/lkml/2008/4/9/4
Handled-By	: Jeff Garzik <jeff@garzik.org>
		  YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
		  Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
		  David S. Miller <davem@davemloft.net>
		  Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Patch		: http://lkml.org/lkml/2008/4/10/409


