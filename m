Return-Path: <linux-kernel-owner+w=401wt.eu-S1759067AbZFDIyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbZFDIyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759086AbZFDIxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:53:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40004
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759069AbZFDIxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:53:39 -0400
Date: Thu, 04 Jun 2009 01:53:40 -0700 (PDT)
Message-Id: <20090604.015340.134497874.davem@davemloft.net>
To: tabbott@mit.edu
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sparc generic read_mostly patches
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tim, I'm fine with these changes, so you can add my:

Acked-by: David S. Miller <davem@davemloft.net>

I would apply these directly to sparc-next-2.6 but the
infrastructure isn't upstream yet so...
