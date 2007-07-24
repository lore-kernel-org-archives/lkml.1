Return-Path: <linux-kernel-owner+w=401wt.eu-S1761086AbXGXGCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086AbXGXGCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 02:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760294AbXGXGBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 02:01:54 -0400
Received: from ws9.cdotb.ernet.in ([202.41.72.121]:52581 "EHLO
	ws9.cdotb.ernet.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759551AbXGXGBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 02:01:53 -0400
X-Greylist: delayed 2012 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2007 02:01:51 EDT
From: "Pallab Dutta" <pallab@cdotb.ernet.in>
To: linux-kernel@vger.kernel.org
Subject: Linux TCP modifications
Date: Tue, 24 Jul 2007 12:11:39 -0400
Message-Id: <20070724160139.M84420@universe.cdotb.ernet.in>
X-Mailer: Open WebMail 2.41 20040926
X-OriginatingIP: 192.168.37.166 (pallab)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
X-imss-version: 2.046
X-imss-result: Passed
X-imss-scanInfo: M:P L:E SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:3.6.1039(15002.003)
X-imss-scores: Clean:1.65400 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to change the TCP ( for a given specific application with lots of
modifications to the basic TCP) implementation in Linux and integrate it with
the linux kernal. Since TCP comes as apart of Linux kernal and also TCP and IP
implementations in Linux are tightly coupled, please suggest how to go about
integrating TCP (which is developed for a specific application with lots of
modifications) into Linux kernal. Kindly give as much details as possible.  

regards,
Pallab.
