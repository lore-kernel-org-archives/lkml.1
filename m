Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYKPWfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYKPWfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 17:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYKPWfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 17:35:40 -0500
Received: from qb-out-0506.google.com ([72.14.204.231]:54857 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbYKPWfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 17:35:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=hUK58TU7snQD40vynjRR3g76MLlKF/GHBBELD9FSu0y+SnVvAjF8UcZbvk98fkfqGW
         0OdcicNVa04FpUN+QTsFr9DwvCy8lsosdsCLruuUFLQNClz50uDGEhBmWioGYX56W72K
         DSI+nZ2CB7oPUomz0r1Z6f/2gml938b9vl+ws=
Date: Mon, 17 Nov 2008 00:35:31 +0200
From: Pekka Paalanen <pq@iki.fi>
To: "Steven Rostedt" <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11996] Tracing framework regression in 2.6.28-rc3
Message-ID: <20081117003531.4c8b5679@daedalus.pq.iki.fi>
In-Reply-To: <Q7OAnAv0V3D.A.GwE.gAGIJB@chimera>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
	<Q7OAnAv0V3D.A.GwE.gAGIJB@chimera>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 17:35:18 +0100 (CET)
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
> Date		: 2008-11-09 10:13 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=122624392229317&w=4
> Handled-By	: Steven Rostedt <rostedt@goodmis.org>

Steve, Ingo, did you get into an agreement on the patch?
What should I test?

I see -rc5 is out, but I didn't spot the fix in the changelog.

(The ring buffer NULL dereference on resize / unallocated max tracer.)

-- 
Pekka Paalanen
http://www.iki.fi/pq/
