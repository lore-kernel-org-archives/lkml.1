Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbXCSSxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbXCSSxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbXCSSxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:53:17 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:57680 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbXCSSxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pO4yOketrSXPXAjOEnNpUYsH86Ji3NOstKZPS/eqDRFkYqmXArOvBybbfwZpzpak9ZdXdaGlIs/ddkD/l269dUC3UiQjtkaenC+PJHJP2MFCI0C/7Q0/n+cEAitMRYJS3Ko6KLC7AaO7kGedk9vvf5TPdgWSlaVCSWCHB2LwaUc=
Message-ID: <b93822910703191153x20249f00vb604a0eda075a23a@mail.gmail.com>
Date: Mon, 19 Mar 2007 19:53:15 +0100
From: "Stefan Prechtel" <stefan.prechtel@googlemail.com>
To: tglx@linutronix.de
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1174326499.13341.517.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <1174325803.13341.515.camel@localhost.localdomain>
	 <1174326499.13341.517.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You can find the files here:
http://bugzilla.kernel.org/show_bug.cgi?id=8235

Regards,
Stefan Prechtel


2007/3/19, Thomas Gleixner <tglx@linutronix.de>:
> On Mon, 2007-03-19 at 18:36 +0100, Thomas Gleixner wrote:
> Oh, a bootlog with ac plugged in would be great too.
>
> Also can you please enable CONFIG_SYSRQ and hit SysRq-Q once, when the
> slowness kicks in.
>
> Thanks,
>
>         tglx
