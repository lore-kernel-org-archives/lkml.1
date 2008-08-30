Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbYH3TsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbYH3TsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYH3Tr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:47:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57693 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbYH3Tr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:47:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Date: Sat, 30 Aug 2008 21:51:41 +0200
User-Agent: KMail/1.9.9
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org> <86802c440808301111i2880a13eq61155b8c7b1ed3dd@mail.gmail.com> <86802c440808301206u2407b77dx6c7119bc398f9529@mail.gmail.com>
In-Reply-To: <86802c440808301206u2407b77dx6c7119bc398f9529@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808302151.43092.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 30 of August 2008, Yinghai Lu wrote:
> On Sat, Aug 30, 2008 at 11:11 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On Sat, Aug 30, 2008 at 10:55 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >> On Sat, Aug 30, 2008 at 10:14 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>
> >>>
> >>> Could you please rebase them on top of current -git?
> >>
> >> please check attached quilt series based on linus tree.
> >
> > there is some problem with fix -v4...on one test machine.
> >
> 
> this one should work.

dmesg -s 262144

http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/dmesg-test.log

cat /proc/iomem

http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/iomem-test.txt

Thanks,
Rafael
