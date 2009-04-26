Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbZDZMfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbZDZMfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 08:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbZDZMdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 08:33:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43851 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbZDZMde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 08:33:34 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Marcel Holtmann" <marcel@holtmann.org>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
In-Reply-To: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <egHshlwQQFE.A.acE.fsE9JB@chimera>
Subject: [Bug #12499] Problem with using bluetooth adaper connected to usb port
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Apr 2009 11:46:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12499
Subject		: Problem with using bluetooth adaper connected to usb port
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-01-13 18:34 (104 days old)
References	: http://marc.info/?l=linux-kernel&m=123187185426236&w=4
Handled-By	: Marcel Holtmann <marcel@holtmann.org>


