Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZGZXTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZGZXTj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZGZXTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:19:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58532 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446AbZGZXTd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:19:33 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Pavel Machek" <pavel@ucw.cz>,
       "Tobias Diedrich" <ranma+kernel@tdiedrich.de>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
In-Reply-To: <Jya1GruKQpD.A.16.2GObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <3zAHs5O6maO.A.KtC.THObKB@chimera>
Subject: [Bug #13826] thinkpad boots with backlight low
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:28:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13826
Subject		: thinkpad boots with backlight low
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-07-15 15:13 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=124756359126830&w=4
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>


