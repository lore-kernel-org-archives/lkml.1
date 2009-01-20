Return-Path: <linux-kernel-owner+w=401wt.eu-S1762954AbZATAdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762954AbZATAdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760060AbZATAd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:33:27 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:34874 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764AbZATAdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:33:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OEDm+fhGXrDTWIh5sHkLf36OzxUqeyiStS7hQkypdp8CyHbwJrz5zOO0/YAetbMnd7
         bVz3h6crnqqhYIbxdPFbGjd8EL2+XxUovHUu4WMC8s6DI1e9O0QKfHKRaFDBoyKYX+Su
         0wtEGpdIXFtv7YF+zllEoOHaF1WXI9UdX11+M=
Message-ID: <81b0412b0901191633y130c4cf0w5531af81c3749ee2@mail.gmail.com>
Date: Tue, 20 Jan 2009 01:33:24 +0100
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12468] Crash in acpi_cpufreq_init
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Alex Riesen" <fork0@users.sf.net>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <2QN7KFic7LG.A.sgH.t9QdJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
	 <2QN7KFic7LG.A.sgH.t9QdJB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/19 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>

The regression is still present.

>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12468
> Subject         : Crash in acpi_cpufreq_init
> Submitter       : Alex Riesen <fork0@users.sf.net>
> Date            : 2009-01-17 10:47 (3 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=50c668d678fd01284799a6e4f1b91829d83cb9ed
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
