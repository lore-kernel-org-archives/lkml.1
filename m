Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYAQCbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYAQCbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYAQC3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:29:30 -0500
Received: from gw.goop.org ([64.81.55.164]:46847 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbYAQC31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:29:27 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 8] x86: refactored paravirt mmu_ops
Message-Id: <patchbomb.1200526038@localhost>
Date: Wed, 16 Jan 2008 15:27:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I refactored the paravirt.h mmu_ops patch into a number of smaller ones.

Thanks,
	J


