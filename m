Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbYKWNNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbYKWNNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 08:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbYKWNNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 08:13:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:47840 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbYKWNNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 08:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=lQAzEB4MOW/YNl0/kmQ53yq4TgcUJAmFz0FDUVmbR1AzfLPbXx0U7WS8rSkqzYmu+3
         AxjcD+uiAJZAxn6g4muiywS/6eATSNUHyiwk5E4sZdOgBZKoGkgUT1fFJXXNuiIk9IGY
         wX/+1YOMmktwJfzjc/NFJ1m3pPvU9wBaq8Auc=
Date: Sun, 23 Nov 2008 15:12:58 +0200
From: Pekka Paalanen <pq@iki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #11996] Tracing framework regression in 2.6.28-rc3
Message-ID: <20081123151258.2e5ed008@daedalus.pq.iki.fi>
In-Reply-To: <vyitTh0pP2N.A.-hC.u7HKJB@chimera>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
	<vyitTh0pP2N.A.-hC.u7HKJB@chimera>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2008 21:28:17 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11996
> Subject		: Tracing framework regression in 2.6.28-rc3
> Submitter	: Pekka Paalanen <pq@iki.fi>
> Date		: 2008-11-09 10:13 (14 days old)
> References	: http://marc.info/?l=linux-kernel&m=122624392229317&w=4
> Handled-By	: Steven Rostedt <rostedt@goodmis.org>

Tested 2.6.28-rc6, this bug is fixed.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
