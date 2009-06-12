Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbZFLRMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbZFLRMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZFLRMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:12:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:4497 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZFLRML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:12:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=L5/eCtrtI45HW9FZl03E2gSLjTNzg8mZM6ktT5mWwNpD7b6d9IXGAp60PeoS0sdt8q
         bXD2wuCFxjczSOFTPh2vK7I5PmRhuKevLKpgOaXGh2Xn4iJ3WIlz0eCMp1JuKQ/GNDk+
         Mj2xqRftG+a/6jdKv8ZJcN+6YPb5H+80HfQ1o=
MIME-Version: 1.0
In-Reply-To: <20090612165716.GA10200@elte.hu>
References: <8bd0f97a0906120513u4e823460t8192f00fd0460ab@mail.gmail.com> 
	<8bd0f97a0906120522v51ae0151i48d5f6846ddcff10@mail.gmail.com> 
	<20090612123152.GE31845@elte.hu> <8bd0f97a0906120541x739b7902pe40ff7aa91337bac@mail.gmail.com> 
	<20090612125941.GI31845@elte.hu> <8bd0f97a0906120604o1e90ac93l469e86173224364e@mail.gmail.com> 
	<20090612130949.GJ31845@elte.hu> <8bd0f97a0906120621o609d7489v83cd3efc0102412d@mail.gmail.com> 
	<20090612135603.GF32105@elte.hu> <20090612165716.GA10200@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Jun 2009 13:11:53 -0400
Message-ID: <8bd0f97a0906121011g5129618bq57c07c2701e544bd@mail.gmail.com>
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open 
	when supported
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 12:57, Ingo Molnar wrote:
> Mike, i'd like to apologize for the tone of this reply - it was
> certainly over the top, especially considering the fact that you
> were right with your original patch :)
>
> Merge window stress is not making me particularly patient i guess
> :-/

all is copacetic
-mike
