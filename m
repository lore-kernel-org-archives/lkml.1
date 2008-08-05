Return-Path: <linux-kernel-owner+w=401wt.eu-S1762701AbYHERRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762701AbYHERRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760907AbYHERRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:17:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37695 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760861AbYHERRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:17:01 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20080805717.971524000@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/4] Updates to the x86 machine check unification
Date: Tue,  5 Aug 2008 19:17:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Should be applied to the respective x86 topic branch.

- Fix Intel thermal handling broken in earlier merge
- Add old code to the deprecation schedule
- Fix a long standing bug in thermal interrupt handling after
suspend to ram 
- Revert older bogus patch

-Andi
