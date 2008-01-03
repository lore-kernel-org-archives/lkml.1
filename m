Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbYACV7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbYACV7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYACV6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:58:33 -0500
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11150 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752739AbYACV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:58:30 -0500
Date: Thu, 03 Jan 2008 14:29:20 -0700
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/4] EDAC code tyding and fixes
Message-ID: <477d53b0.Lr5g0bmce0sqZVxd%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Doug Thompson <dougthompson@xmission.com>

This EDAC patch set was applied against: 2.6.24-rc6-mm1

1) Fixed a pci parity regression
2) enabled i3000 building under x86_64 as well as for x86
3) limit scope of variable by adding static to mpc85xx
4) added missing initialization code to i3000

Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
