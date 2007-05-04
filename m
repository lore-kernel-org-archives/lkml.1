Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbXEDRZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbXEDRZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161366AbXEDRZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:25:58 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:8758 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161306AbXEDRZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:25:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PurGjISEs9JSDriJn7G9kd/Mb3I/3dRmzjd2OBoPwP7MP2beKY1FF9pRpKoYhOslLpG/RdR9xH9J75NlTqwfjpZbqvlHdlplME5jOnA2ugMRad5W/eUEfhyChgL5GqtRdv9EvdEYMopQ+sEfPKVH0DhbyGTyG/CfFKWHw29MKW8=
Message-ID: <5486cca80705041025k46ccf716t8dcd1e6f29e2376e@mail.gmail.com>
Date: Fri, 4 May 2007 19:25:49 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Paul Fulghum" <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1178299247.3769.0.camel@amdx2.microgate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <5486cca80705040233y70915a27yf7cbbc08a617e3ba@mail.gmail.com>
	 <463B46F4.6090906@microgate.com> <463B4988.9090005@microgate.com>
	 <1178290160.3913.2.camel@amdx2.microgate.com>
	 <5486cca80705040904v786f13dh5614174fcc51c202@mail.gmail.com>
	 <5486cca80705040956g47f634ddp80d67038e8e3305a@mail.gmail.com>
	 <463B7534.6000207@microgate.com>
	 <5486cca80705041013pf481c2an9e639fc9285ba88e@mail.gmail.com>
	 <1178299247.3769.0.camel@amdx2.microgate.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Paul Fulghum <paulkf@microgate.com> wrote:
> On Fri, 2007-05-04 at 19:13 +0200, Antonino Ingargiola wrote:
> > On 5/4/07, Paul Fulghum <paulkf@microgate.com> wrote:
> > > Antonino Ingargiola wrote:
> > > > The system blocks during booting. I can unblock it with SysReq+K but
> > > > then I'm unable to log into X.
> > >
> > > Hmmm, it tests here with no problem.
> > >
> > > Does reversing the patch and rebuilding the kernel fix the boot?
> >
> > The kernel to which I applied the patch was vanilla 2.6.21.1, and it
> > is the one I'm currently running (no config changes or other patches).
>
> Are you using a serial port as console?
>

No. Ehmm ... I've an usb keybord and vga monitor on a standard desktop pc.

Regards,

  ~ Antonio
