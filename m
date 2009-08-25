Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZHYIPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZHYIPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZHYIPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:15:12 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:56967 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbZHYIPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:15:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LzDTkWfv+RVgMEcp/RyZmSJFwpxUYgoYYXS2i0PXwbda0SCAjJwxyStK6ik+ksyzmz
         XBGEbMr4jYft6DFwZeGuh7LhoB6lRDAEU1Qb9BiEcv066TpR6FsKNzpeSfcZbXiE+3+A
         0+JwV9qFaEVQUx/aciVRfvDNuAWrhnTT+FEIM=
MIME-Version: 1.0
In-Reply-To: <1251143422-13905-1-git-send-email-Mario_Limonciello@Dell.com>
References: <9b2b86520908220420p282c862fn9c44697db010a08d@mail.gmail.com>
	 <1251143422-13905-1-git-send-email-Mario_Limonciello@Dell.com>
Date: Tue, 25 Aug 2009 09:15:10 +0100
Message-ID: <9b2b86520908250115r2281fd66w8536f4e3817ea8b9@mail.gmail.com>
Subject: Re: [PATCH] compal-laptop: Replace sysfs support with rfkill support
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mario Limonciello <Mario_Limonciello@dell.com>
Cc: cezary.jackiewicz@gmail.com, linux-wireless@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/09, Mario Limonciello <Mario_Limonciello@dell.com> wrote:
> This drops the support for manually groking the files in sysfs
> to turn on and off the WLAN and BT for Compal laptops in favor
> of platform rfkill support.
>
> It has been combined into a single patch to not introduce regressions
> in the process of simply adding rfkill support

Ok, that looks better.

Thanks
Alan
