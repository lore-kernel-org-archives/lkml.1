Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYC1PC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYC1PC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 11:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758627AbYC1PBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 11:01:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:33627 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230AbYC1PBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 11:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:user-agent:date:from:to:cc:subject;
        b=X0ocAwnFdlEFUOdvTof4cksBdIy3pCOjyNYx+JnIOR5cZ6VBL0y7fUuvx1q3QTGwPOenxgqWz5RK0PJtQ3ZnE9JmiMAB+UuNrC5OmOePuGN/Y7t4dsjYOh+fBrgLPwIzThTfJuKCGvfDea/+tHirnZ+bIx2+g4gRl99FQgU2/kU=
Message-Id: <20080328145655.076024373@gmail.com>
User-Agent: quilt/0.46-1
Date: Fri, 28 Mar 2008 17:56:55 +0300
From: gorcunov@gmail.com
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Cc: gorcunov@gmail.com, linux-kernel@vger.kernel.org
Subject: [patch 0/2] x86 flags cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series does remove some flags from x86.h. We should better
use ones from processor-flags.h

Please review (and if it possible, give them a strong test, Ingo)
Any comments appreciated

		- Cyrill -
-- 
