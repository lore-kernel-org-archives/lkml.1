Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0BGXQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 18:16:43 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45304 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab0BGXQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 18:16:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=Bms7wFV6xfK80jjjrsqTV2Oqmx8/CpQg8rZEQtCAP4tlqjRRZutGzEjD0GEDDJCJDN
         xcN8QFysnQhHJM2iwn1cb1AcsWPIBtJ9RKgvPv+Ow8wsTl7MYNunm9HFwCQ2dtURPbYO
         /ftAj/TaQ+RuM1wSxnKc6FdPCQ1xHSLSPgYGE=
From: =?utf-8?q?Mat=C4=9Bj_Laitl?= <strohel@gmail.com>
Organization: FJFI =?utf-8?q?=C4=8CVUT?=
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #15114] X.org hang with [drm:i915_gem_do_execbuffer] *ERROR* in dmesg
Date: Mon, 8 Feb 2010 00:16:35 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc6-00228-g56dca4c; KDE/4.4.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera> <445R0ey9hAI.A.1tB.7ozbLB@chimera>
In-Reply-To: <445R0ey9hAI.A.1tB.7ozbLB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002080016.36393.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 February 2010 23:28:50 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let the
> tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15114
> Subject		: X.org hang with [drm:i915_gem_do_execbuffer] *ERROR* in dmesg
> Submitter	: Matej Laitl <strohel@gmail.com>
> Date		: 2010-01-23 19:54 (16 days old)

I confirm the regression still exists in 2.6.33-rc6-00228-g56dca4c

Regards,
		Matej Laitl
