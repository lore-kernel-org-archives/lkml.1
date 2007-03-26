Return-Path: <linux-kernel-owner+w=401wt.eu-S933211AbXCZA2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbXCZA2I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 20:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933235AbXCZA2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 20:28:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933211AbXCZA2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 20:28:07 -0400
Message-ID: <46071395.20203@redhat.com>
Date: Sun, 25 Mar 2007 20:28:05 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Interrupt posted but not delivered
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've now seen several reports of this message from the 3Com
3c59x driver.  This seems to be a very old problem that has
somehow come back starting with kernel 2.6.19 AFAICT. What
could cause this?

