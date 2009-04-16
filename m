Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbZDQAhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbZDQAhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759492AbZDQAdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:33:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36528 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759467AbZDQAdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:33:31 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nY3-4PrO6XH.A.L8.dw85JB@chimera>
Subject: [Bug #13098] 2.6.29-git12 breaks vga=0x0f07 on MSI/Intel GPU
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 Apr 2009 23:45:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13098
Subject		: 2.6.29-git12 breaks vga=0x0f07 on MSI/Intel GPU
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2009-04-06 01:14 (11 days old)
References	: http://lkml.org/lkml/2009/4/5/200
Handled-By	: H. Peter Anvin <hpa@zytor.com>


