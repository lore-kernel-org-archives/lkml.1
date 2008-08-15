Return-Path: <linux-kernel-owner+w=401wt.eu-S1761109AbYHOTKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761109AbYHOTKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758270AbYHOTKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:10:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:17766 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147AbYHOTKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=K8iRN/e21POyexx9tdBw+L6YFYLv+UkKPbGZ4F2H1oAh84DnI8mOHVIzeuKgpPzi1C
         TFRKTtn122bYS1rxwdADDWFmWYfMan8RuSSzi+RVmn196HVABE3sbvC5IygFc9dMGxAo
         gCXYVoV3fr3EkCWAo0cixmypKSm4F90EFugXU=
User-Agent: quilt/0.46-1
Date: Fri, 15 Aug 2008 23:05:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/2] apic fixes, unification continued
Message-ID: <48a5d4a4.0637560a.1985.fffffd73@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Ingo, Maciej,

here is updated series (well... two patches only :).
Nothing that new - just fixed the parts wich were
not well formed in previous series.

Please review.

CID: tip/master 1a2450e636df465318fd9dcd31e37ea6af300405

		- Cyrill -
-- 
