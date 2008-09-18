Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbYIRP0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbYIRP0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbYIRP02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:26:28 -0400
Received: from ryu.zarb.org ([212.85.158.22]:45824 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833AbYIRP01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:26:27 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2008 11:26:27 EDT
Subject: edd breaking vesafb
From: Pascal Terjan <pterjan@mandriva.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Mandriva
Date: Thu, 18 Sep 2008 17:17:15 +0200
Message-Id: <1221751035.26693.8.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.92-1mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I got a report of vesafb no longer working since edd is used on a
machine (Shuttle FN41SP).
It's a BIOS bug that was easily workarounded by calling set_video before
query_edd.
Does someone see some issue in doing that ?

