Return-Path: <linux-kernel-owner+w=401wt.eu-S936040AbXGWUow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936040AbXGWUow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXGWUok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:44:40 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:6132 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762439AbXGWUoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KnMY1T87HrFQe6HJqwskyXCFBj1ZXbQ/1xLzs1pUzej7HD6RIshvmTTcRS/QMW9ZDDLM4umG34lP4nsMpic8I/rp0piwdOvJ+FxurjpCdHCejBM7gFcL6GhO0Z7x28p+jlyqcfTwc3uH7mD3VfhnYiyamIr+TagOLBK+i7MUlSQ=
Message-ID: <5a4c581d0707231344w2943d5e5p6eece5f0bc0f98c2@mail.gmail.com>
Date: Mon, 23 Jul 2007 22:44:37 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "=?ISO-8859-1?Q?Ismail_D=F6nmez?=" <ismail@pardus.org.tr>
Subject: Re: Linus 2.6.23-rc1
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, len.brown@intel.com
In-Reply-To: <200707231957.00794.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <46A4DACC.3090007@googlemail.com>
	 <200707231957.00794.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/07, Ismail Dönmez <ismail@pardus.org.tr> wrote:
> On Monday 23 July 2007 19:43:56 Gabriel C wrote:
> > I get some ACPI Exception.
> >
> > ...
> >
> > [   33.075429] ACPI Exception (processor_throttling-0084): AE_NOT_FOUND,
> > Evaluating _PTC [20070126] [   33.075437] ACPI Exception
> > (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126] [
> > 33.075490] ACPI Exception (processor_throttling-0084): AE_NOT_FOUND,
> > Evaluating _PTC [20070126] [   33.075497] ACPI Exception
> > (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126] [
> > 33.075529] ACPI Exception (processor_throttling-0084): AE_NOT_FOUND,
> > Evaluating _PTC [20070126] [   33.075536] ACPI Exception
> > (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126] [
> > 33.075563] ACPI Exception (processor_throttling-0084): AE_NOT_FOUND,
> > Evaluating _PTC [20070126] [   33.075570] ACPI Exception
> > (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]
> >
>
> Same here, I was about to blame my holy Vaio, but latest ACPI merge is to
> blame instead.

Add me too, Dell D610, 2.6.23-rc1 on top of Fedora 7.

--alessandro

 "Did you get married but forgot to get divorced ?"

     (Danny and Dusty, 'The Good Old Days')
