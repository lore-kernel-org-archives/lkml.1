Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYLPJZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYLPJZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYLPJZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:25:39 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:50587 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYLPJZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:25:39 -0500
Message-Id: <20081216091544.061115344@linux.vnet.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 16 Dec 2008 10:15:44 +0100
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 0/1] hvc_console: send magic sysrq key to terminal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the patch allows to send the magic sysrq key to the terminal (if pressed twice),
so that it can be consumed by applications (e.g. ^0 is used by some editors...)


Ben, Paul, could you add the patch to your powerpc tree?

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

