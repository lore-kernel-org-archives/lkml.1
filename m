Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbYISOiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbYISOiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYISOhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:37:46 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48836 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751808AbYISOhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:37:45 -0400
Message-Id: <20080919143744.009764000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Fri, 19 Sep 2008 07:37:44 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] SGI X86 UV: Provide a System Activity Indicator driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Provide an SCIR driver for SGI UV systems...

Based on: linux-2.6.tip/master.

Signed-of-by: Mike Travis <travis@sgi.com>

