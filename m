Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbYEJCK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbYEJCK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 22:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbYEJCKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 22:10:19 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60792 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751371AbYEJCKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 22:10:16 -0400
Message-Id: <20080510020947.803480649@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 19:09:47 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Cc: travis@sgi.com
Subject: [patch 0/6] x86: Unification patches etc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some patches that have so far not been merged. Various fixes
after running this on a variety of configurations. Builds on
8 different 32 bit / 64 bit configs.

-- 
