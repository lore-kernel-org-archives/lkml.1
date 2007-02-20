Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbXBTBEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbXBTBEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 20:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbXBTBEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 20:04:54 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:25902 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750AbXBTBEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 20:04:52 -0500
Date: Mon, 19 Feb 2007 19:00:56 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH 0/5] sata_nv: various cleanups and fixes
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>
Message-id: <45DA4848.7090407@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains several fixes for issues I noticed while
debugging some command timeout problems. None of these proved to be
related to that issue, but they fall into the category of things
we should be doing anyway.

Split into separate patches to ease bisecting in case of issues.



