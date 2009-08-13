Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbZHMAs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbZHMAs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 20:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbZHMAs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 20:48:26 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:54353 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZHMAsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 20:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=gEiIM5kx1YoSZp2kb4ZnZC3P3FB6MIRNPg9Dltpr9Ec5GsHsLsFtCk8Y1oDUggPRzl
         V9aR38NdXJkyCBF3TSQ2yKTxjZbx/iEa22pz263fuUkQOMu60egUq7Tb4crHjrUHB6Pw
         vlO14XIyfitbmTkugrGcr0Jb61ihhcNJZ5Egs=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] MAINTAINERS: Add "L: linux-arm@vger.kernel.org" to ARM sections
Date: Thu, 13 Aug 2009 02:48:04 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-1-amd64; KDE/4.3.0; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Joe Perches <joe@perches.com>, Ben Dooks <ben-linux@fluff.org>,
       David John <davidjon@xenontk.org>, Erik Mouw <mouw@nl.linux.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>
References: <4A7ACC8D.7030706@xenontk.org> <1250118277.12423.7.camel@pc1117.cambridge.arm.com> <20090812232220.GE24667@n2100.arm.linux.org.uk>
In-Reply-To: <20090812232220.GE24667@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908130248.05104.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Čt 13. srpna 2009 01:22:20 Russell King - ARM Linux napsal(a):
> On Thu, Aug 13, 2009 at 12:04:37AM +0100, Catalin Marinas wrote:
> > For the other ARM MAINTAINERS entries (e.g. specific boards), it is up
> > to the corresponding maintainers to add whatever lists they want, which
> > may include linux-arm@vger.
>
> Just to be clear (and my final email tonight) I don't have a problem
> with that, provided the corresponding maintainers do agree (and
> therefore provide their ack).
>
> But to do it as a blanket "add linux-arm@vger to everything with
> linux-arm-kernel" is wrong.

Hi,

what about setting this ML so it forwards all emails (or all that dont have 
vger in CC/To) to vger ? And maybe then broadcasting the list of people 
subscribed to this ML that they should subscribe to vger ?

Though it might be a lot of traffic.

Cheers!
>
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
