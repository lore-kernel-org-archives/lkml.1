Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYHKNP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYHKNP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYHKNPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:15:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:57448 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYHKNPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:15:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JBxVg4NhK6zTUR9lb1pGR51GfomaLmZgwnE+7edyJY2kbZx/1WqUOEFNNar2LHqMIm
         D4ZJ+bIsgJuOkAnDGKBOxcEDCeodq8Ur2gFB0Si1fa80F2i/8DGzFj4ra1e2Za4KRZBz
         RJYfRyJb1AGwhqmvfbBzej2UdMSB4w67zozZ0=
Message-ID: <514e099a0808110615i42ade5dctc31d87b483095e35@mail.gmail.com>
Date: Mon, 11 Aug 2008 06:15:09 -0700
From: "S K" <nospamnoham@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Cc: "Zhao Yakui" <yakui.zhao@intel.com>, "Thomas Renninger" <trenn@suse.de>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <874p5r3jow.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com>
	 <200808081430.43012.trenn@suse.de>
	 <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
	 <200808092059.47863.trenn@suse.de>
	 <514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com>
	 <1218418431.6671.52.camel@yakui_zhao.sh.intel.com>
	 <514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com>
	 <1218432270.6671.75.camel@yakui_zhao.sh.intel.com>
	 <874p5r3jow.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It sounds like the BIOS just doesn't support frequency scaling.
> Perhaps it's disabled in the BIOS setup. Or the system doesn't
> support it at all.

It works in Windows XP, so I'm not sure if it's only a BIOS issue.
If it's not that simple, then care to impart some knowledge?

Thanks,
SK
