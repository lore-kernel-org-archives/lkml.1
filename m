Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYINTc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYINTc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 15:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbYINTcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 15:32:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbYINTcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 15:32:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Frank Mayhar <fmayhar@google.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
In-Reply-To: Ingo Molnar's message of  Sunday, 14 September 2008 17:14:04 +0200 <20080914151404.GA28850@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
	<20080914151404.GA28850@elte.hu>
X-Shopping-List: (1) Diligent imports
   (2) Chinese Honkers
   (3) Astigmatic Ritz Cracker Crumb expectations
   (4) Gaunt dirt
   (5) Cervical chain witches
Message-Id: <20080914193140.728F56409D@pipsqueak.localdomain>
Date: Sun, 14 Sep 2008 12:31:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> please uninline these functions.

They are short and have only one caller.


Thanks,
Roland
