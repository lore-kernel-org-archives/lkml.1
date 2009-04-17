Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbZDQB3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbZDQB3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759140AbZDQB26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:28:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:6922 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007AbZDQB24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vHLlTGcFJnZuiF5gZuMBqkrNGCkH2tt5DEl3u9ILskZKnk2jdLSbkz5ew6REl3za6s
         7ZIFKxmINbb5eA1MDqy+MCa8NG5ptye+VyYLSIJ6dnkhRry22BiPHsSrbvFWZRN/dO9z
         aYkex9s1B6v0p9wotpSU2b8jpoBo1a9NVCD/0=
MIME-Version: 1.0
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
Date: Fri, 17 Apr 2009 09:28:54 +0800
Message-ID: <b6a2187b0904161828h33ad84d4y8074c993a43dd146@mail.gmail.com>
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 5:42 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13118
> Subject         : iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Date            : 2009-04-10 16:05 (7 days old)
> References      : http://lkml.org/lkml/2009/4/10/111
> Handled-By      : Eric Dumazet <dada1@cosmosbay.com>

Several iterations of patches in progress. See
[PATCH] netfilter: per-cpu spin-lock with recursion (v0.8)


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13066
> Subject         : Intel HD Audio oops
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Date            : 2009-04-01 8:28 (16 days old)
> References      : http://marc.info/?l=linux-kernel&m=123857454625829&w=4

Fixed as of April 09 2009 git pull.


Thanks,
Jeff
