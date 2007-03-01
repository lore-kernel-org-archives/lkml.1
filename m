Return-Path: <linux-kernel-owner+w=401wt.eu-S965163AbXCAPPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965163AbXCAPPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965180AbXCAPPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:15:22 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:33486 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965163AbXCAPPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:15:19 -0500
X-IronPort-AV: i="4.14,234,1170651600"; 
   d="scan'208"; a="29509249:sNHT87228736"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Bernhard Walle" <bernhard.walle@gmx.de>
Subject: Re: MOST(Media Oriented Systems Transport) Interface?
Date: Thu, 1 Mar 2007 10:16:08 -0500
User-Agent: KMail/1.9.5
Cc: "Jan Kiszka" <jan.kiszka@web.de>, linux-kernel@vger.kernel.org,
       gernot.hillier@siemens.com
References: <200702231826.30395.rgetz@blackfin.uclinux.org> <45E60EBD.2090806@web.de> <20070301001142.GA6806@strauss.suse.de>
In-Reply-To: <20070301001142.GA6806@strauss.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011016.08167.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 01 Mar 2007 15:15:17.0189 (UTC) FILETIME=[6B414750:01C75C14]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 28 Feb 2007 19:11, Bernhard Walle pondered:
> * Jan Kiszka <jan.kiszka@web.de> [2007-03-01 00:22]:
> > This might be what you are looking for:
> >
> > http://most4linux.sourceforge.net/

That's it - thanks for the pointer & Bernhard - thanks for the work.

What is the plan for this? It looks like you did the work on 2.6.14, what is 
the plan going forward? Is this something that you or anyone else wants to 
maintain/support newer devices on?

> It only supports synchronous data transfer. The Most NetServices are
> in userspace. There's a OpenSource demonstration available, but no
> full NetServices implementation. You can buy a license from SMC or use
> the specification to re-write an OSS implementation. However, that's
> all userspace, so no GPL problem here. :)

Is there any effort on making an open source NetServices implementation?

Thanks
-Robin
