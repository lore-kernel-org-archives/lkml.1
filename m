Return-Path: <linux-kernel-owner+w=401wt.eu-S968726AbXEIGog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968726AbXEIGog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 02:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967702AbXEIGo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 02:44:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967716AbXEIGo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 02:44:26 -0400
From: Bernhard Schiffner <bernhard@schiffner-limbach.de>
To: linux-kernel@vger.kernel.org
Subject: CFS & rt-preempt : orthogonal patches possible ?
Date: Wed, 9 May 2007 08:44:18 +0200
User-Agent: KMail/1.9.4
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705090844.19000.bernhard@schiffner-limbach.de>
X-Provags-ID: V01U2FsdGVkX1/Stp3CekrypHll3xPkrI6y6b/jQRu5MEz2Zmc
 QqyH76nmuZoBva7nVo/9QtLVp1Nw7a94KdWVoSDSfPHoDll9KC
 mN5C6fN1ui2ctUOPESXgq4JbsBXlq6T
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo (Ingo),

testing something regarding linuxpps I want to do it against the "latest 
and greatest kernel ever" too.

rt-preempt is common from audio already.
CFS something new and promising.

But the patches conflict in their combination.

Is there something against this type of combination?
Is there perhaps a solution?

TIA

Bernhard

PS: ck's SD-patch conflicts too...
