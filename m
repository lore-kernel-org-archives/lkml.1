Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbYAVFcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbYAVFcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 00:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYAVFcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 00:32:47 -0500
Received: from smtp113.plus.mail.re1.yahoo.com ([69.147.102.76]:30211 "HELO
	smtp113.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751512AbYAVFcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 00:32:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=IzDUsDsV9ms1kCjGmW9QnPPqxobU88CwX5O+b3oJqUW+6w0IePokhBgyXdX6WQ5UFJGFvkUgP/CoOHuCQBR/4aOlT5tBaUlWws8QUA/Gp/vvvgAoKZGkk4cvKeJNDs5DOcVG7vyhancjtaQvutTKXxQuRFXf5v2JyqBYu0pLwXs=  ;
X-YMail-OSG: IGcW4yAVM1kvHPyM0bwrDAghkz37CzODUK3KgPFK_bu9ayUx0oP.qqhrVo1VT.7yMLWCSv.NjQ--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 22 Jan 2008 06:32:31 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/12] ide-floppy redux v2.5
Message-ID: <20080122053231.GA20570@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de> <200801142238.17282.bzolnier@gmail.com> <20080120123815.GA20082@gollum.tnic> <200801212345.35762.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801212345.35762.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 11:45:35PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi Borislav,
> 
> On Sunday 20 January 2008, Borislav Petkov wrote:
> > On Mon, Jan 14, 2008 at 10:38:17PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > > By the way, I have an Iomega ZIP 100 drive somewhere in my hardware pile and
> > > > will do some testing with the "new" :) driver just in case.
> > > 
> > > This would be great. :)
> > Hi Bart,
> > 
> > i just whipped rc8 along with your pata-2.6 tree on top and had several test
> > runs of the ide-floppy driver (raw reads, software floppy disk eject, etc) and
> > everything seems to work fine. I will keep this hardware setup here so that we
> > could at least test ide-floppy occasionally. We should probably acknowledge this
> 
> Big thanks for all great ide-floppy work!  I hope that you'll continue with
> putting IDE device drivers in shape. :)

Sure, no problem :). I'm on ide-tape right now and probably will have most of it
ready for submission on the weekend so keep your fingers crossed... :)

-- 
Regards/Gruﬂ,
    Boris.
