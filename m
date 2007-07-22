Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbXGVSOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbXGVSOl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbXGVSOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:14:25 -0400
Received: from homer.mvista.com ([63.81.120.158]:55878 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762059AbXGVSOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:14:23 -0400
Subject: v2.6.22.1-rt4-dw2
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       sven@thebigcorporation.com
Content-Type: text/plain
Date: Sun, 22 Jul 2007 11:03:59 -0700
Message-Id: <1185127439.2573.21.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I released another version of my tree .. It's still based on
2.6.22.1-rt4 . It's even more bisectable, but still not fully
bisectable.

I included the two fixes I post earlier today,

[PATCH -rt] temporary WARN_ON removal
[PATCH -rt] drop spurious rcu unlock

Here's the combined patch,

ftp://source.mvista.com/pub/dwalker/rt/patch-2.6.22.1-rt4-dw2

And the broken out set,

ftp://source.mvista.com/pub/dwalker/rt/patch-2.6.22.1-rt4-dw2-broken-out.tar.gz


The release notes for 2.6.22.1-rt4 also apply to this patch.

Daniel

