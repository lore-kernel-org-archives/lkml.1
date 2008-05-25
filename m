Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbYEYHVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbYEYHVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 03:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYEYHVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 03:21:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:63963 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbYEYHVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 03:21:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tUdi+Wcge2rk+Lay3Lz9haHbq7rFoxzTgRxq73iwuUlB0IyactadF1FFmRYhLgHLXq8yWWVY61k38HJ74P343zUgRKCdoPzL+vymmjvSZpDVpmstHlSRF5XxqOXPPfMu2U+OYrglmR67qj8+eTe7A13ZVvJ/LDtrpCS8CbKzLBc=
Message-ID: <b637ec0b0805250021k5883fcb6w71ded44f3adf4173@mail.gmail.com>
Date: Sun, 25 May 2008 09:21:01 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10724] ACPI : EC: GPE
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Justin Mattock" <justinmattock@gmail.com>
In-Reply-To: <dd18b0c30805241608o35915aa9l3759b5a50785279@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
	 <TW_YzGo9TFP.A.erD.jeIOIB@albercik>
	 <dd18b0c30805241608o35915aa9l3759b5a50785279@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
I just pulled Linus' GIT tree and the message seems to have
disappeared. Before today it showed reliably on every boot.

Regards,
Fabio




On Sun, May 25, 2008 at 1:08 AM, Justin Mattock <justinmattock@gmail.com> wrote:
> On Sat, May 24, 2008 at 8:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.25.  Please verify if it still should be listed.
>>
>>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10724
>> Subject         : ACPI : EC: GPE
>> Submitter       : Justin Mattock <justinmattock@gmail.com>
>> Date            : 2008-05-16 6:17 (9 days old)
>> References      : http://marc.info/?l=linux-kernel&amp;m=121091875711824&amp;w=4
>>                  http://lkml.org/lkml/2008/5/18/168
>>
>>
>>
>
> Hello; This message seems to be appearing on a random, (every x amount
> of boots). At first I thought this was resolved with adjusting the
> .config
> but didn't seem to be the answer. Also I have third party modules
> installed i.g.(isight driver, and dri driver) which also might be
> causing this.
> I guess the best answer is if somebody else can verify this happens to
> them, with all in kernel modules. I on the other hand will unload
> the third party modules and see if this appears.
> regards;
>
>
> --
> Justin P. Mattock
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
