Return-Path: <linux-kernel-owner+w=401wt.eu-S932955AbXBZWlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955AbXBZWlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932647AbXBZWlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:41:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37379
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932955AbXBZWlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:41:35 -0500
Date: Mon, 26 Feb 2007 14:41:34 -0800 (PST)
Message-Id: <20070226.144134.95506510.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: davej@redhat.com
Subject: cpufreq build regression added today
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Dave, please test your const'ification changes, else you'll
leave some of us const'ipated :-)

drivers/cpufreq/cpufreq.c: In function 'cpufreq_register_driver'
drivers/cpufreq/cpufreq.c:1767: error: assignment of read-only location

Thanks.
