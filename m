Return-Path: <linux-kernel-owner+w=401wt.eu-S1030863AbXDJPgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030863AbXDJPgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030866AbXDJPga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:36:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030863AbXDJPga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:36:30 -0400
Message-ID: <461BAEFB.2020809@redhat.com>
Date: Tue, 10 Apr 2007 11:36:27 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Wanted: irqpoll enhancement to show what is misrouted
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can irqpoll be enhanced to show which interrupts are being misrouted?
It looks like it should be possible to show the actual interrupt,
the driver that is handling it, and what interrupt it's expecting
in a /proc file -- just what happened last time irqpoll resolved
the interrupt would be better than nothing.
