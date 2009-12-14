Return-Path: <linux-kernel-owner+w=401wt.eu-S932206AbZLNMVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbZLNMVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932132AbZLNMVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:21:36 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:56089 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbZLNMVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:21:32 -0500
From: Mithlesh Thukral <mithlesh@linsyssoft.com>
To: devel@driverdev.osuosl.org
Subject: Re: [How to upload our driver to "kernel.org"] Would you give me your  advice?
Date: Mon, 14 Dec 2009 17:51:36 +0530
User-Agent: KMail/1.12.3 (Linux/2.6.31.5-127.fc12.i686.PAE; KDE/4.3.3; i686; ; )
Cc: Alejandro Riveira =?utf-8?q?Fern=C3=A1ndez?= <ariveira@gmail.com>,
       Masa <masa.korg@gmail.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
References: <c7ac85d60912140256j4e1aa0edn9abba53ab1855ed5@mail.gmail.com> <20091214122649.2d914941@varda>
In-Reply-To: <20091214122649.2d914941@varda>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912141751.36699.mithlesh@linsyssoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replies are inline.

Regards,
Mithlesh Thukral

On Monday 14 December 2009 16:56:49 Alejandro Riveira Fernández wrote:
> El Mon, 14 Dec 2009 19:56:23 +0900
> Masa <masa.korg@gmail.com> escribió:
> 
> Adding I hpe some usefull CC's
> See also: http://www.linuxdriverproject.org/
> 
> > Hi,
> >
> > Our company is planning to upload our device drivers to "kernel.org".
> > And I am investigating "How to upload".
SubmittingDrivers in the Documentation/ can help you with this.
Online copy can be found at (amongst many more):
	http://lxr.linux.no/#linux+v2.6.32/Documentation/SubmittingDrivers


> >
> > Our company is developing some device drivers for new chip-set device.
> > It is not released yet, but the sample is in the test in the specific
> > company.
> >
> > I contacted kernel.org this month.
> > The man recommended this mailing-list.
> >
> > Would you give me your advice?
> > I am very glad if you help it.
> >
> > We look forward to uploading the drivers to kernel.org!
> >
> > [Our drivers]
> > We are preparing the drivers source code.
> > And we uploaded them to Sourceforge.net.
> > Please refer to below.
> > http://sourceforge.net/projects/generalembedded/
> > http://generalembedded.sourceforge.net/
> >
> > Our developers will turn our drivers into a patch series and to post
> > them to this mailing list.
> >
If you intend to post the drivers as the development effort continues. so that 
you can have the community feedback (and if required help) during the process 
then you might in interested in Greg's Staging tree.
	http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=tree
You can base your patches to the latest kernel (or git trees of respective 
maintainers) and post them to the mailing list.

> > [My information]
> > I participated in the mailing list for the first time in my life.
> > I am full of fears and hopes.
> >
> > This mailing list is very lively and great!
> > I think so.
> >
> > Thank you & Best regards,
> > Masa <masa.korg@gmail.com>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
> 
