Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbYLPUS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbYLPUS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYLPUSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:18:45 -0500
Received: from gw.goop.org ([64.81.55.164]:45879 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbYLPUSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:18:44 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use of
	swiotlb
Message-Id: <patchbomb.1229458644@abulafia.goop.org>
Date: Tue, 16 Dec 2008 12:17:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jan Beulich <jbeulich@novell.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's some patches to clean up swiotlb to prepare for some Xen dom0
patches.  These have been posted before, but undergone a round of
cleanups to address various comments.

Thanks,
	J

