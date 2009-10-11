Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbZJKW0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbZJKW0D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZJKW0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:26:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57842 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbZJKWZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:25:58 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jose Marino" <braket@hotmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
In-Reply-To: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <r-4Wjt4coy.A.orD.yal0KB@chimera>
Subject: [Bug #14334] pcmcia suspend regression from 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 00:22:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14334
Subject		: pcmcia suspend regression from 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Submitter	: Jose Marino <braket@hotmail.com>
Date		: 2009-10-06 15:44 (6 days old)


