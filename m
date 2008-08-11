Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbYHKIw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbYHKIw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 04:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYHKIwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 04:52:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:3580 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbYHKIws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 04:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Catr4ppWn73STGME3PSw/Zqx6EtF79O6i47FuLVKBcPTVsOOrGvsb6eqDxltU7yNbP
         Z+UInNJZGBjaJqOGX/t/nheShmyw/gpuNH6DGHtS0ygl+d7uMGNrK+805bFHYCC14rVT
         vaMoEpGqwjJs+PMgriD/mqDgHxTptUqBOXBEI=
Message-ID: <b647ffbd0808110152s5787bb08k679851f82647df43@mail.gmail.com>
Date: Mon, 11 Aug 2008 10:52:47 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: [Bug #11288] Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <cX_-nNkxKaF.A.bnH.aCjnIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
	 <cX_-nNkxKaF.A.bnH.aCjnIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/10 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).

I've not yet received any feedback from Mark whether the patch
suggested by me does fix a problem for him.


-- 
Best regards,
Dmitry Adamushko
