Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbYERQ6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbYERQ6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 12:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYERQ6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 12:58:41 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:14454 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYERQ6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 12:58:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mRwhYxoTb8eK3xZ0Y0d6EBQeNKRmT0XjGpWdH8LQYVBaTXvNgCZEcyXjD+vKF2AAIyV8PRBBiKB5dp820kox96azWrDIdN/XE/63mlWmUPVI98TNLBUmtbW92Z5A3fnGqe9RfHB5p96H5Y28hnUMgLaKNaGe+99cxmvyUNLxYkk=
Message-ID: <dd18b0c30805180958v1c6cadebm39ecd67518a7b5d0@mail.gmail.com>
Date: Sun, 18 May 2008 16:58:37 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10724] ACPI : EC: GPE
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <7wuznNhcUqC.A.b1G.srBMIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	 <7wuznNhcUqC.A.b1G.srBMIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 11:13 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10724
> Subject         : ACPI : EC: GPE
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-05-16 6:17 (3 days old)
> References      : http://marc.info/?l=linux-kernel&amp;m=121091875711824&amp;w=4
>
>
>


Looking at my var/log/* it's been two days and I have not received
this message, The only configuration change was disabling irq
balancing,
changing 300MHZ to 100MHZ, and choosing y to CONFIG_PREEMPT_NONE=y.
As for keeping  this bug report open, well if two day is adequate, for
this kind of message. I don't have a problem with closing this report,
but then again you don't want to close this report then a couple of
kernel versions later see this message again, and then have to
go and file another of the same report, unless the person who fixed
this is positively sure this message, has been taken care of.
As for the fan issue I was talking about in my previous post, please
ignore that, I messed up, I forgot to put into account that
where I reside, we are experiencing a heat wave,("no wonder the fans rev up").
regards;


-- 
Justin P. Mattock
