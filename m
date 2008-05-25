Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbYEYJfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbYEYJfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 05:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbYEYJfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 05:35:33 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:60351 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbYEYJfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 05:35:32 -0400
Date: Sun, 25 May 2008 11:35:31 +0200
Message-Id: <290982711@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Shuduo Sang <sangshuduo@gmail.com>
Cc: bosko.radivojevic@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Inserting code from userspace to kernel space
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18ekSEpBWZ9NkCUzYr1kMS5LHsv0AdPhs8IevNyOtf3JlxRZ
 oXEFft0pdPkfU6Fnm9Tu/K2UmMQ9XETHQ+KMgPlyVgvVupP6vM=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> someone does not want to leak propertied algorithm out with GPL. This
> can be a way to protect.

this can be illegal, too.

http://www.gnu.org/licenses/gpl-faq.html#ModifiedJustBinary

>Can I release a modified version of a GPL-covered program in binary form only?
>No. The whole point of the GPL is that all modified versions must be free software — which means, 
>in particular, that the source code of the modified version is available to the users




> On Fri, May 23, 2008 at 10:30 PM,  <devzero@web.de> wrote:
> >>> I know this sounds quite weird, but maybe there is a project that can help us ;)
> >>>
> >>
> >>actually you can implement a parser/interpretor, whatever you name it,
> >>in kernel space. And you can send the
> >>function code from user space to kernel space by device driver
> >>interface. the parser can parse that and do something
> >>practical function in kernel.
> >>
> >>I have worked on a similar task in a product powered by linux. It works great.
> >
> > any pointer to the sourcecode so bosko (and others) can profit from that ?
> >
> 
> someone does not want to leak propertied algorithm out with GPL. This
> can be a way to protect.
> 
> >
> >
> >
> > List:       linux-kernel
> > Subject:    Re: Inserting code from userspace to kernel space
> > From:       "Shuduo Sang" <sangshuduo () gmail ! com>
> > Date:       2008-05-22 16:04:35
> > Message-ID: ee101c360805220904h1c69db12q3048d0347d27c461 () mail ! gmail ! com
> > [Download message RAW]
> >
> > On Thu, May 22, 2008 at 8:41 PM, Bosko Radivojevic
> > <bosko.radivojevic@gmail.com> wrote:
> >> Hi!
> >>
> >> I'm looking for a way to insert code from user space to the kernel
> >> space, but without using kernel module. Actually, we are working on a
> >> system that has to allow end user to change part of code (one or two
> >> functions) that is executed from the kernel space.
> >>
> >> For now we have two different kernel modules, one exporting a function
> >> which another module uses. Process of compiling kernel module is quite
> >> ineligible for standard end user (along with the requirement to
> >> support multi platform cross compiling) compared to just cross
> >> compiling a simple code that doesn't use any libraries than libc.
> >>
> >> I know this sounds quite weird, but maybe there is a project that can help us ;)
> >>
> >
> > actually you can implement a parser/interpretor, whatever you name it,
> > in kernel space. And you can send the
> > function code from user space to kernel space by device driver
> > interface. the parser can parse that and do something
> > practical function in kernel.
> >
> > I have worked on a similar task in a product powered by linux. It works great.
> >
> >> Sincerely,
> >> Bosko
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> > ______________________________________________________________
> > Jeden Monat 1 hochkarätiger maxdome-Blockbuster GRATIS!
> > Exklusiv für alle WEB.DE Nutzer. http://www.blockbuster.web.de
> >
> >
> 


_______________________________________________________________
Schon gehört? Der neue WEB.DE MultiMessenger kann`s mit allen: 
http://www.produkte.web.de/messenger/?did=3016

