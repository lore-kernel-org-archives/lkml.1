Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbYHSTbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbYHSTbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbYHSTao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:30:44 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48854 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbYHSTan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:30:43 -0400
Message-ID: <48AB1EA2.4070904@cs.helsinki.fi>
Date: Tue, 19 Aug 2008 22:27:30 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rdunlap@xenotime.net,
       mpm@selenic.com, tglx@linutronix.de, rostedt@goodmis.org,
       cl@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       tzanussi@gmail.com
Subject: Re: [PATCH 1/5] Revert "kmemtrace: fix printk format warnings"
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro>
In-Reply-To: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard - Gabriel Munteanu wrote:
> This reverts commit 79cf3d5e207243eecb1c4331c569e17700fa08fa.
> 
> The reverted commit, while it fixed printk format warnings, it resulted in
> marker-probe format mismatches. Another approach should be used to fix
> these warnings.

I simply dropped Randy's patch so the revert wasn't needed.
