Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbYIMDY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbYIMDY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 23:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbYIMDYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 23:24:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:28838 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499AbYIMDYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 23:24:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J52rtoJvbK2dH6NNzW/WkD7G6DJdhm6RM0o0jKK57enIIwYdrOJLWA/8ufBhKOSklF
         ywGLjFZkICgviAUbrQsECm83XIO6ZAGqdKrQ8yWoQycuTXpmLQp/7UfiwViLxSOaShuU
         O0xFDy2ldNy2Tixac8TRKcP4dybKX5uw46sfs=
Message-ID: <dd18b0c30809122024g7fc2f77cpc3dedd8d7d1053a5@mail.gmail.com>
Date: Fri, 12 Sep 2008 20:24:48 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11552] Disabling IRQ #23
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
In-Reply-To: <SpS7rta8n4.A.h8F.xbsyIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	 <SpS7rta8n4.A.h8F.xbsyIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 12:06 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11552
> Subject         : Disabling IRQ #23
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-09-09 19:08 (4 days old)
> References      : http://marc.info/?l=linux-kernel&m=122098735230906&w=4
>                  http://marc.info/?l=linux-kernel&m=122107367715361&w=4
> Handled-By      : Yinghai Lu <yhlu.kernel@gmail.com>
>
>
>

yeah I think it would be a good idea.
something to do with ehci_hcd, i.g. if I blacklist
ehci_hcd  Disabling IRQ#23 message doesnt seem to be showing up.

-- 
Justin P. Mattock
