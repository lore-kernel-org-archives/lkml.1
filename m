Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbYERMo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbYERMo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbYERMoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:44:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59682 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbYERMop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:44:45 -0400
Date: Sun, 18 May 2008 14:44:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [Bug #10650] 2.6.26-rcX VC console scrolling regression
In-Reply-To: <7wuznNhcUqC.A.af.1sBMIB@albercik>
Message-ID: <alpine.LNX.1.10.0805181443230.15590@fbirervta.pbzchgretzou.qr>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.af.1sBMIB@albercik>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2008-05-18 13:13, Rafael J. Wysocki wrote:

>This message has been generated automatically as a part of a report
>of recent regressions.
>
>The following bug entry is on the current list of known regressions
>from 2.6.25.  Please verify if it still should be listed.
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10650
>Subject		: 2.6.26-rcX VC console scrolling regression
>Submitter	: David Miller <davem@davemloft.net>
>Date		: 2008-05-07 21:46 (12 days old)
>References	: http://lkml.org/lkml/2008/5/8/9
>Handled-By	: Jan Engelhardt <jengelh@medozas.de>

Fix has been merged; v2.6.26-rc2-104-g7fe3915.
