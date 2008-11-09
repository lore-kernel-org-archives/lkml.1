Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbYKIUGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbYKIUGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbYKIT5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:57:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44506 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580AbYKIT5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:57:18 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bernhard Schmidt" <berni@birkenwald.de>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Jiri Kosina" <jikos@suse.cz>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
In-Reply-To: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wnN9HICUAgP.A.WbF.X4zFJB@chimera>
Subject: [Bug #11984] regression when switching TTY-&gt;X, input related?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 18:59:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11984
Subject		: regression when switching TTY-&gt;X, input related?
Submitter	: Bernhard Schmidt <berni@birkenwald.de>
Date		: 2008-11-05 22:04 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=122592278403853&w=4


