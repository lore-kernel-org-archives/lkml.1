Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbZHEVva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbZHEVva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZHEVv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:51:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42932 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbZHEVv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:51:28 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <200908051151.557035535@firstfloor.org>
To: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [0/5] kbuild: A couple of Kbuild fixes/improvements
Date: Wed,  5 Aug 2009 23:51:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some build system patches that accumulated in my tree:

- Fix mcount handling
- Fix gold linker support
- Add some gcc 4.5 support

One will address the problem Dave A. reported earlier today.

-Andi
