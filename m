Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYLGUJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYLGUJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 15:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbYLGUJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 15:09:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34483 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbYLGUJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 15:09:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Fabio Comolli" <fabio.comolli@gmail.com>
Subject: Re: [Bug #12155] Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Date: Sun, 7 Dec 2008 21:08:26 +0100
User-Agent: KMail/1.9.9
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera> <b637ec0b0812061208i9520bd0tfd404f1a9c8a95ba@mail.gmail.com> <b637ec0b0812070539i20684ec2tfc6748f01d99fff9@mail.gmail.com>
In-Reply-To: <b637ec0b0812070539i20684ec2tfc6748f01d99fff9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072108.26246.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 7 of December 2008, Fabio Comolli wrote:
> Hi.
> 
> On Sat, Dec 6, 2008 at 9:08 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> > Hi Rafael.
> >
> > On Thu, Dec 4, 2008 at 9:50 AM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> >> Hi.
> >>
> >> I'll try -rc7-git probably tonight and 2.6.27.8 when -stable team releases it.
> >>
> >
> > 2.6.28-rc7 survived 7 suspend/resume cycles and then showed the bug.
> 
> 2.6.27.8 got me really scared. After the resume and the usual hang, my
> hard disk did not recover and my rootfilesystem's journal aborted. Of
> course I don't have messages to post as the rootfs was at this point
> mounted readonly. I read those info from dmesg.
> 
> I went back to my dear 2.6.27.4 which is stable and never caused me
> any problems.
> 
> Unless someone jumps in with some ideas, I'm not going to do testings
> anymore. I can't lose my only machine because of this.

OK, thanks for the testing so far.

Please just ignore the subsequent automatic messages about this regression.

Thanks,
Rafael
