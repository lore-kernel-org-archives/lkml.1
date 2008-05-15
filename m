Return-Path: <linux-kernel-owner+w=401wt.eu-S1760473AbYEOOAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbYEOOAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbYEOOAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:00:44 -0400
Received: from main.gmane.org ([80.91.229.2]:55920 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbYEOOAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:00:43 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Weird Xorg radeon mirroring with linux-next-20080515
Date: Thu, 15 May 2008 15:00:29 +0100
Message-ID: <g0hflu$b4q$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When using the radeon xorg driver with linux-next-20080515 there is a
strange mirroring/stretching effect in the bottom eighth of the screen. The
problem seems to have started sometime between linux-next-20080513 and 
linux-next-20080515.

(Do you always have to have done bisection before reporting regressions?)

-- 
Sitsofe

