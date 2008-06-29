Return-Path: <linux-kernel-owner+w=401wt.eu-S1760661AbYF2TeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661AbYF2TeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758874AbYF2TbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:31:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45672 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758834AbYF2TbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:31:23 -0400
Cc: "Christian Casteyde" <casteyde.christian@free.fr>,
       "Ivo van Doorn" <IvDoorn@gmail.com>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
In-Reply-To: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <X8mbwW6K81I.A.ecF.c89ZIB@albercik>
Subject: [Bug #10821] rt25xx: lock dependency warning, association failure, and kmalloc corruption
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jun 2008 20:18:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10821
Subject		: rt25xx: lock dependency warning, association failure, and kmalloc corruption
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-05-29 14:30 (32 days old)
Handled-By	: Ivo van Doorn <IvDoorn@gmail.com>


