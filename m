Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZBRSQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZBRSQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZBRSQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:16:32 -0500
Received: from mail.vyatta.com ([76.74.103.46]:38349 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZBRSQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:16:31 -0500
Date: Wed, 18 Feb 2009 10:16:28 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: hpa@zytor.com, mingo@redhat.com, shemminger@vyatta.com, tglx@linutronix.de,
       kaber@trash.net, davem@davemloft.net, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, linux-tip-commits@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, kaber@trash.net,
       davem@davemloft.net
Subject: Re: [tip:timers/new-apis] timers: add mod_timer_pending()
Message-ID: <20090218101628.39e4a5a2@extreme>
In-Reply-To: <tip-526e8d0daddd679431e898ab072ae1ca71bd5685@kernel.org>
References: <tip-526e8d0daddd679431e898ab072ae1ca71bd5685@kernel.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 13:51:30 GMT
Ingo Molnar <mingo@elte.hu> wrote:

> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Wed, 18 Feb 2009 12:23:29 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 18 Feb 2009 14:47:57 +0100
> 
> timers: add mod_timer_pending()
> 
> Impact: new timer API
> 
> Based on an idea from Stephen Hemminger: introduce
>  mod_timer_pending() which is a mod_timer() offspring
> that is an invariant on already removed timers.

Acked-by: Stephen Hemminger <shemminger@vyatta.com>

Actually, credit for this goes to  Martin Josefsson with help from Patrick.
