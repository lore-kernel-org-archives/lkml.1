Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbYGWWZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbYGWWZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbYGWWZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:25:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51813
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753161AbYGWWZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:25:30 -0400
Date: Wed, 23 Jul 2008 15:25:29 -0700 (PDT)
Message-Id: <20080723.152529.223079425.davem@davemloft.net>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, ranjitm@google.com, balbir@in.ibm.com,
       clg@fr.ibm.com, ebiederm@xmission.com, kaber@trash.net,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com,
       rohitseth@google.com
Subject: Re: + cgroups-traffic-control-cgroups-subsystem.patch added to -mm
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <200807232205.m6NM5moR014333@imap1.linux-foundation.org>
References: <200807232205.m6NM5moR014333@imap1.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew, we are actively reviewing and looking over these networking
cgroup changes.  Likely, they still have problems that either
Patrick or someone else will spot during the next round of review.

Therefore, there is really no need for you to add them to -mm at this
time.

Thanks.
