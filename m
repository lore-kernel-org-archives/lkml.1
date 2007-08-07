Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbXHGTdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbXHGTdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 15:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbXHGTdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 15:33:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbXHGTdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 15:33:17 -0400
Message-ID: <46B8C8FA.9020100@redhat.com>
Date: Tue, 07 Aug 2007 15:33:14 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Dmitry Torokhov <dtor@insightbb.com>
Subject: 2.6.22: pcspkr driver no longer loads automatically
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With no other changes but a kernel upgrade, the pcspkr driver
doesn't load automatically anymore. No changes to that driver
jump out, so where else could the problem be? Something to
do with the device class changes maybe?
