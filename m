Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYDJOlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYDJOlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757532AbYDJOlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:41:35 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:56470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbYDJOle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:41:34 -0400
Message-Id: <20080410134810.629048000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Thu, 10 Apr 2008 15:48:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@freedesktop.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: [RFC 0/3] Examples for the new sparse context tracking
	functionality
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some patches that show how the new sparse functionality  
could be used in the kernel if merged.

As mentioned before, I have actually found three bugs in mac80211
using these patches. If you apply them and the sparse patches I have
also just posted, you can find them too :)

johannes

