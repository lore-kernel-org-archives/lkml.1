Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbXDJWI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbXDJWI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbXDJWI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:08:58 -0400
Received: from [212.12.190.85] ([212.12.190.85]:35789 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753965AbXDJWI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:08:57 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/30] Use menuconfig objects
Date: Wed, 11 Apr 2007 01:12:39 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704110112.39425.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> the following patch series turns some menus into menuconfigs, so they
> can be disabled whilst "walking" thorugh the parent menu

Great, but instead of making it a simple on/off, make it tri-state that would 
default select all child-options appropriately.  (see HW_RANDOM)


Thanks!

--
Al



