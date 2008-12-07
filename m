Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYLGTSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYLGTSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 14:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYLGTRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 14:17:51 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:43932 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbYLGTRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 14:17:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=TWzo0mAZjXn1Ji2S5ZqAI+a0t4Hewm/pbTfFUi3uBqQIoqZNsekvvtBN8SC2b3AcSG
         FldraVsejrRjSCtgfl2inO7tf2WifxiuAqI8ebv9+D9g0zBey7QQbRiyw6nvaYbF+6XI
         WrVcDqMiANMa0xkJt1T60t53MtJwiuqlUjnh8=
From: Frederik <mailinglists.fredi@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12161] [i915 drm] irq 16: nobody cared with latest git kernels
Date: Sun, 7 Dec 2008 20:16:34 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc3; KDE/4.1.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera> <bfPM5B8Tx2B.A.SrG.ooxNJB@chimera>
In-Reply-To: <bfPM5B8Tx2B.A.SrG.ooxNJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072016.35510.mailinglists.fredi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,
On Wednesday 03 December 2008 22:58:06 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).

This regression is present on kernels newer than 2.4.28-rc3. Unfortunately it 
needs time to hit this bug so there's no easy way to bisect it ... And BTW 
there is a bugzilla entry here for this issue: 

https://bugs.freedesktop.org/show_bug.cgi?id=18609


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12161
> Subject		: [i915 drm] irq 16: nobody cared with latest git kernels
> Submitter	: fredi ml <mailinglists.fredi@gmail.com>
> Date		: 2008-12-02 13:26 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=122822444615724&w=4

Thanks,
Frederik
