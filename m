Return-Path: <linux-kernel-owner+w=401wt.eu-S1762217AbYEKVO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762217AbYEKVO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758957AbYEKVB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34199 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237AbYEKVBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:52 -0400
Cc: "Arjan van de Ven" <arjan@linux.intel.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.Z1F.Tv1JIB@chimera>
Subject: [Bug #10677] Error in save_stack_trace() on x86_64?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10677
Subject		: Error in save_stack_trace() on x86_64?
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-05-11 13:09 (1 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121051140821821&amp;w=4
Handled-By	: Arjan van de Ven <arjan@linux.intel.com>


