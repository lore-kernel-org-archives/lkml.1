Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbZE1BgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbZE1BgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 21:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbZE1BgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 21:36:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:60703 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbZE1BgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 21:36:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=DXYN6lbnwpb2HR43ENvSWh0/Os2VB6nszWtLmr9ybZQhDIhUGQCnzwh4TS9hvNo5p/
         BBJzB1DnFXvaKFu0XtEmFwBxNIZGtsF7nH/2fitdrg8oJzMOP9hPf1iGymb4SgGH0dsk
         +3rfPAH5iMejjXiq735c6PwNBCdFwILlooe9A=
Subject: [RESEND] [PATCH 0/2 V3] description about static priority.
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       tglx <tglx@linutronix.de>, williams <williams@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1242884360.31161.77.camel@centos51>
References: <1242884360.31161.77.camel@centos51>
Content-Type: text/plain
Organization: Private
Date: Thu, 28 May 2009 10:36:06 +0900
Message-Id: <1243474566.14685.35.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-- 
>From c2e8f308730c87010d50a72f80ede6b7f308497e Mon Sep 17 00:00:00 2001
From: GeunSik,Lim <leemgs1@gmail.com>
Date: Thu, 28 May 2009 10:08:00 +0900
Subject: [PATCH 0/2] description about static priority. 

Dear Ingo Molnar,

This is static priority description related patch files. 

Please, merge my patch.

Thanks,

GeunSik,Lim (2):
  ftrace: fix typo about map of kernel priority in ftrace.txt file.
  sched: fix typo in sched-rt-group.txt file

 Documentation/scheduler/sched-rt-group.txt |    2 +-
 Documentation/trace/ftrace.txt             |   15 ++++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)





-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim (  S A M S U N G     E L E C T R O N I C S  )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

