Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbZDGQqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbZDGQqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbZDGQqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:46:14 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:29016 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbZDGQqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PdECmU8TjogJoGmnuQQ8liAPKEYC+WhhyQ/ijO4P5q4JrVNwqe9p1cFtxFD7btybO2
         dGD594UK5pf2moRXGCuFxDM8U/5ifY5oOlIGqDHsgoVodO9mQs6B+vuZwSCvwC5k43PB
         5levrfGB8pkItMVO9kQCHpn974aaxYYTJqoZE=
Date: Wed, 8 Apr 2009 00:47:08 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Henrik Austad <henrik@austad.us>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Ziljstra <peterz@infradead.org>
Subject: Re: [PATCH 0/2] sched: make the scheduler (even) more modular
Message-ID: <20090407164708.GH12226@hack>
References: <1239111373-12774-1-git-send-email-henrik@austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239111373-12774-1-git-send-email-henrik@austad.us>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 03:36:11PM +0200, Henrik Austad wrote:
>Several of the functions in the core scheduler tests explicitly for class and 
>then to class-specific operations. This should be handled by the sched_class 
>interface.
>
>This patch-series moves 2 such elements over to sched_entity, or more precisely, 
>the priority part.
>
>Ingo, Peter: I forgot to CC lkml the last time around, sorry about this resend.
>

I like these two patches! Really nice!

You can add my reviewed-by if you need:

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

