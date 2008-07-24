Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbYGXLoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbYGXLoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYGXLny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:43:54 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:51787 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbYGXLny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:subject;
        b=Fgm7LXLA7X8+wVYiFGSM0lsAYIyD078S0be7jTIojw9+UhEvfXxRMs3qey70ynMYuL
         q51n4PfjxH2GJZNUGXWADNstbq4FO1dkxB1xTwr/gAH8mrR7xnbNiKETRza+NahGtRbg
         sbvQf1cjSQcrQ23xS4OZlCXt5Nml8S5JfsHoM=
Message-Id: <20080724114302.028278487@gmail.com>
User-Agent: quilt/0.46-1
Date: Thu, 24 Jul 2008 15:43:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, macro@linux-mips.org
Subject: [patch 0/2] x86 apic - a few function merge v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  I don't leave hope to merge APIC code someday (now it becomes harder
'cause of new x(2)APIC code). So these patches merges a few functions.
No changes on binary level. Please review. Any comments are welcome!

  The patches are made on top of -tip tree

commit d55ee73e46e89547aca7ca83a2df80bf70d9d1d1
Merge: 6a807a0... 695a6b4...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 23 13:21:26 2008 +0200

    Merge branch 'cpus4096'

		- Cyrill -
-- 
