Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbZCDJDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbZCDJDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZCDJCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:02:49 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:64454 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZCDJCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:02:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Uv2H9+RCc1JY+xFVwIWYhVH52k2MSWvZ4/A0SiY2QnDF7ESWkYnRnEKgoTzNZR4hjO
         JKBFI1TZMReFngzf6tfz6eEwP0JpGKQkE35xZDuw+sRVaGWeeCl3PUQSsAJ1QtFlM6Pj
         5CdIZaANm/8nQa19NSYxfqVwYlx05sVRZV1BI=
MIME-Version: 1.0
In-Reply-To: <SLCXkuHtxAO.A.nSG.-WarJB@chimera>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
	 <SLCXkuHtxAO.A.nSG.-WarJB@chimera>
Date: Wed, 4 Mar 2009 11:02:44 +0200
X-Google-Sender-Auth: 2cdeef1411ae794e
Message-ID: <84144f020903040102o1ddc6ee7l31bf4cf928092773@mail.gmail.com>
Subject: Re: [Bug #12501] build bug in eeepc-laptop.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       rui.zhang@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 3, 2009 at 9:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12501
> Subject         : build bug in eeepc-laptop.c
> Submitter       : Ingo Molnar <mingo@elte.hu>
> Date            : 2009-01-14 17:25 (49 days old)
> References      : http://lkml.org/lkml/2009/1/14/315

There's seems to be a patch for the bug here:

http://bugzilla.kernel.org/attachment.cgi?id=20341&action=view
