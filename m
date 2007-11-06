Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbXKGOIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbXKGOIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbXKGOIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:08:18 -0500
Received: from host-66-43-248-10 ([67.55.143.10]:58129 "EHLO albrecht.rdi1.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754033AbXKGOIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:08:18 -0500
X-Greylist: delayed 58076 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2007 09:08:18 EST
Subject: unionfs and sys_readahead
From: Paul Albrecht <albrecht@rdi1.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Nov 2007 16:01:21 -0600
Message-Id: <1194386482.7489.5.camel@albrecht.rdi1.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Whenever I use readahead-list on a union mounted file system I get a
segfault and kernel oops so I'm wondering whether or not the linux
unionfs supports sys_readahead.

Anyone know? I'm not usually subscribed to the lkml so please cc me in
your response. Thanks.

Paul Albrecht

