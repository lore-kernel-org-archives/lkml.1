Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbZEPW1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbZEPW1I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758337AbZEPWQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:16:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43916 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758215AbZEPWQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:16:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luca Tettamanti" <kronos.it@gmail.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <385Pu-agh7M.A.BhH.VYzDKB@chimera>
Subject: [Bug #13329] cifs_close: NULL pointer dereference
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 21:20:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13329
Subject		: cifs_close: NULL pointer dereference
Submitter	: Luca Tettamanti <kronos.it@gmail.com>
Date		: 2009-05-16 16:28 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=124249133701702&w=4


