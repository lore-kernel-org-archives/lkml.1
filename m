Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab0AORio (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 12:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757620Ab0AORin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 12:38:43 -0500
Received: from fom01.emnet.dk ([89.249.14.84]:48304 "EHLO fom01.emnet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab0AORim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 12:38:42 -0500
X-AuditID: 59f90e54-b7bd7ae000001243-81-4b50a820cdd2
Subject: option driver freezing entire system
From: Kasper Sandberg <lkml@metanurb.dk>
To: smurf@smurf.noris.de
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Jan 2010 18:38:36 +0100
Message-Id: <1263577116.27788.131.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello..

Im having some issues with some huawei e1752 modems, the computer
sometimes completely freezes, and i suspect its due to the option
driver, as it doesnt happen if i dont modeswitch them to appear as
option modem.

Do you have any idea what might cause this? i looked all over the system
logs and theres nothing to help at all, but i have seen this spanning
from .26 to .32, on multiple computers, and i just dont know what to do
to fix it.

Thanks in advance

