Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbYKRLjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbYKRLjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 06:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYKRLiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 06:38:52 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:49693 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYKRLiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:38:51 -0500
Message-Id: <20081118112827.927627788@linux.vnet.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Nov 2008 12:28:27 +0100
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 0/1] hvc_console: fix: remove duplicate hp->ws winsize check
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this patch fixes a hvc terminal resize problem by removing a duplicate
winsize comparison.

Ben, could you add this patch to your tree for 2.6.28-rc6 bug fixes?

Thanks and regards,
Hendrik

-- 
Hendrik Brueckner
D/3303 Linux on System z Development
eMail: brueckner@linux.vnet.ibm.com
IBM Deutschland Research & Development GmbH, Schoenaicher Str. 220, 71032 Boeblingen

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschaeftsfuehrung: Erich Baier
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

