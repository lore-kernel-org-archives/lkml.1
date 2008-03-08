Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYCHWzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYCHWzM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 17:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYCHWzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 17:55:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57667 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYCHWy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 17:54:59 -0500
Subject: Re: 2.6.25-rc4 OOMs itself dead on bootup (modprobe bug?)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jon Masters <jcm@redhat.com>
Cc: Frank Sorenson <frank@tuxrocks.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1205013197.5484.81.camel@perihelion>
References: <47D02940.1030707@tuxrocks.com> <20080306184954.GA15492@elte.hu>
	 <47D1971A.7070500@tuxrocks.com> <47D23B7E.3020505@tuxrocks.com>
	 <20080308135318.GA8036@auslistsprd01.us.dell.com>
	 <47D29CAB.50301@tuxrocks.com>  <1205013197.5484.81.camel@perihelion>
Content-Type: text/plain
Date: Sat, 08 Mar 2008 23:54:44 +0100
Message-Id: <1205016884.24056.1.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.91 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+cNkJeUx+Z134YZLkkkM45BArZeAHNX5ZFL93
 ulKO7XweRIVFCJq5C3/vhm/mBlHkgEzYStBeYwuu6eg3HOtRRg
 NjnZp4s9/lq3thFLrnZqf/YINvOfCWC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-08 at 16:53 -0500, Jon Masters wrote:
> On Sat, 2008-03-08 at 08:03 -0600, Frank Sorenson wrote:
> 
> > It's module-init-tools-3.4-2.fc8.x86_64 (most recent Fedora rpm available).
> 
> Ok, so I'll see if I can find a Dell system in the office to reproduce
> this on Monday. Any Dell should do, right Matt?

Should not be needed:
  http://lkml.org/lkml/2008/3/8/91

Cheers,
Kay

