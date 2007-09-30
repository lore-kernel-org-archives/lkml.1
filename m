Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbXI3Ppk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbXI3Ppk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbXI3Ppd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:45:33 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:37152 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755714AbXI3Ppc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:45:32 -0400
From: Florian Schmidt <mista.tapas@gmx.net>
To: "Lee Revell" <rlrevell@joe-job.com>
Subject: Re: getting FUSD compiled with current kernels
Date: Sun, 30 Sep 2007 17:45:36 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200709291823.35868.mista.tapas@gmx.net> <75b66ecd0709291826j64c45bcdoc957411f0fb25689@mail.gmail.com> <200709301429.53101.mista.tapas@gmx.net>
In-Reply-To: <200709301429.53101.mista.tapas@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709301745.37163.mista.tapas@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 September 2007, Florian Schmidt wrote:
> On Sunday 30 September 2007, Lee Revell wrote:
> > On 9/29/07, Florian Schmidt <mista.tapas@gmx.net> wrote:
> > > My goal is to hack up oss2jack [3] to use ALSA pcm devices.. And a
> > > later goal is to create a virtual ALSA soundcard [which would multiplex
> > > access to a real non hw-mixing capable soundcard] to finally end the
> > > dmix software mixing woes linux users have to endure for the last years
> > > :)
> >
> > What problems with ALSA's userspace mixing are you trying to solve?

[snip]

Thinking about it some more i think the plan isn't quite as simple to 
implement as i thought..

Some more work would have to be done than to simply provide the device file 
infrastructure of an ALSA device driver.. Well, right now, i'm happy enough 
to have oss2jack and kfusd built and running.. 

Regards,
Flo

-- 
Palimm Palimm!
http://tapas.affenbande.org
