Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbYHJAL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbYHJAL6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbYHJAJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:09:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47359 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbYHJAJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:09:54 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
In-Reply-To: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX_-nNkxKaF.A.jfC.JEjnIB@albercik>
Subject: [Bug #11214] 2.6.27-rc1: I/O errors after resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Aug 2008 00:43:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11214
Subject		: 2.6.27-rc1: I/O errors after resume
Submitter	: Miklos Szeredi <miklos@szeredi.hu>
Date		: 2008-07-31 13:04 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121750960431966&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


