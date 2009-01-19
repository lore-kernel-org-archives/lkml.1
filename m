Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbZASXwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbZASXwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760356AbZASXvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:51:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40279 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760231AbZASXvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:51:39 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jan Beulich" <jbeulich@novell.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
In-Reply-To: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <2QN7KFic7LG.A.cl.C-QdJB@chimera>
Subject: [Bug #12416] Recent change to kernel spikes out ccache/distcc
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:32:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12416
Subject		: Recent change to kernel spikes out ccache/distcc
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2009-01-06 15:15 (14 days old)
References	: http://marc.info/?l=linux-kernel&m=123125495000603&w=4


