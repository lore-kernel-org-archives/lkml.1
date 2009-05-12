Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbZELD24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbZELD24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 23:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbZELD2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 23:28:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34556 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421AbZELD2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 23:28:46 -0400
Message-ID: <4A08ECE1.30406@redhat.com>
Date: Tue, 12 May 2009 11:28:33 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: merge process.c a bit
References: <20090512020614.4891.63987.sendpatchset@localhost.localdomain>
In-Reply-To: <20090512020614.4891.63987.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang wrote:
> Merge arch_align_stack() and arch_randomize_brk(), since
> they are the same.
>
> Tested on x86_64.
>
> Cc: Ingo Molnar <mingo@elte.hu>
>   

Oops! I forgot my Signed-off-by... sorry.

Signed-off-by: WANG Cong <amwang@redhat.com>

