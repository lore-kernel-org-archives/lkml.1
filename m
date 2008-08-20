Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbYHTOfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbYHTOfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYHTOfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:35:02 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:46143 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYHTOfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:35:00 -0400
X-Greylist: delayed 4555 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Aug 2008 10:35:00 EDT
Subject: distributed shared memory / mmap
From: Martin Uecker <muecker@gwdg.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Biomedizinische NMR Forschungs GmbH
Date: Wed, 20 Aug 2008 15:18:56 +0200
Message-Id: <1219238336.8097.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi!

Is there any easy way to get shared memory between to
processes on different machines? It seems possible using mmap
on a file system like GFS on top of a distributed block device.


Sincerly,
Martin Uecker



