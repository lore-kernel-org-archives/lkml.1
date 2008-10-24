Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbYJXMcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbYJXMcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 08:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYJXMcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 08:32:24 -0400
Received: from nebensachen.de ([195.34.83.29]:45959 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbYJXMcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 08:32:23 -0400
X-Hashcash: 1:20:081024:tglx@linutronix.de::y2aXIKs+mfriwkHe:000000000000000000000000000000000000000000037Gb
X-Hashcash: 1:20:081024:stable@kernel.org::7nG/ecoByjC0GZNw:000000000000000000000000000000000000000000000HCs
X-Hashcash: 1:20:081024:linux-kernel@vger.kernel.org::ALCTLY+CygVqjBWn:000000000000000000000000000000000208d
From: Elias Oltmanns <eo@nebensachen.de>
To: Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: NOHZ fixes for stable?
Date: Fri, 24 Oct 2008 14:32:12 +0200
Message-ID: <87ljwetbqr.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

would these changes have a chance to go into a stable release?

fb02fbc1 (NOHZ: restart tick device from irq_enter())
c4bd822e (NOHZ: fix thinko in the timer restart code path)

Regards,

Elias
