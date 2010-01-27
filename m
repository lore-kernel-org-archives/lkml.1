Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974Ab0A0Mlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab0A0Mlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 07:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397Ab0A0Mlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 07:41:42 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:63849 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab0A0Mll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 07:41:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sYzHEMiB+PmXJPMsX+UeVFVXb/Hr5Whu2uyPXTw/46NKWRaWpMSuEd9kCQ0vOxZ6aw
         d7+J1aVnyhnrEYEfrwXKEie4xmMt+QHVv/ckk6qJrXOJ4f1RKAUwt6kB6jYOn5Xc6FT4
         Ik9b4W2as7ywjeBrc+doKurnSqJdc9XOq9Ygs=
MIME-Version: 1.0
In-Reply-To: <q60Z28d_9yH.A._eB.HbMXLB@chimera>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
	 <q60Z28d_9yH.A._eB.HbMXLB@chimera>
Date: Wed, 27 Jan 2010 14:41:39 +0200
X-Google-Sender-Auth: 3143e525c1a8ec0a
Message-ID: <84144f021001270441t75441bebpc605ac8c0cfedbd1@mail.gmail.com>
Subject: Re: [Bug #14657] perf subsystem breakage in 2.6.32-rc7
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I am CC'ing some more perf folks.)

On Mon, Jan 25, 2010 at 12:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14657
> Subject         : perf subsystem breakage in 2.6.32-rc7
> Submitter       : Arjan van de Ven <arjan@infradead.org>
> Date            : 2009-11-19 19:50 (67 days old)
> References      : http://marc.info/?l=linux-kernel&m=125866013419738&w=4

Is this bug still valid?
