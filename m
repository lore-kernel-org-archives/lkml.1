Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbZEXWQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbZEXWQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759183AbZEXWJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:09:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34276 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759221AbZEXWJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:09:29 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "" <patrick@ostenberg.de>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
In-Reply-To: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uSztiUhmDDC.A.k6H.Z9bGKB@chimera>
Subject: [Bug #13341] Random Oops at boot at loading ip6tables rules
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 May 2009 21:11:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13341
Subject		: Random Oops at boot at loading ip6tables rules
Submitter	:  <patrick@ostenberg.de>
Date		: 2009-05-19 09:08 (6 days old)


