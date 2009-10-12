Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbZJLRKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbZJLRKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZJLRKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:10:46 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:60462 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZJLRKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:10:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v7PkFPAaq8WodVI8IgrXgEovCLp3DlTIfthQ7eA8yZyjpm5/A915zIv02WoAolRnJ7
         CNXXBnPUlbAPlTvXvLpZBn0djZafYE6tikha2KuNypyRSflJnMhwHJDoRlP5WUNaiqnx
         cpICwiOtVGlWkIKmWFeke7m1w7u/nVg6B1tNw=
MIME-Version: 1.0
In-Reply-To: <L6tb-VyKHZK.A.LUE.p0l0KB@chimera>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	 <L6tb-VyKHZK.A.LUE.p0l0KB@chimera>
Date: Mon, 12 Oct 2009 19:10:07 +0200
Message-ID: <e2e108260910121010l7855ad67g903cceac1a3ba024@mail.gmail.com>
Subject: Re: [Bug #14070] lockdep warning triggered by dup_fd
From: Bart Van Assche <bart.vanassche@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 1:01 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14070
> Subject         : lockdep warning triggered by dup_fd
> Submitter       : Bart Van Assche <bart.vanassche@gmail.com>
> Date            : 2009-08-23 09:36 (50 days old)
> References      : http://lkml.org/lkml/2009/8/23/8
>

Hello Rafael,

Since I reported the above issue I haven't seen it reappearing yet.

Bart.
