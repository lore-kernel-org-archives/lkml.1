Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYC3LsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYC3LsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 07:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYC3Lr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 07:47:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50548 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbYC3Lr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 07:47:58 -0400
Date: Sun, 30 Mar 2008 13:48:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: bugme-daemon@bugzilla.kernel.org, rjw@sisk.pl, bunk@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [Bug 10345] USB HID problems after resume
Message-ID: <20080330114834.GA6510@elf.ucw.cz>
References: <20080328223544.A61F711D10C@picon.linux-foundation.org> <47EE78C9.5090006@rtr.ca> <47EE793C.5070105@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EE793C.5070105@rtr.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-03-29 13:15:40, Mark Lord wrote:
> bugme-daemon@bugzilla.kernel.org wrote:
>> http://bugzilla.kernel.org/show_bug.cgi?id=10345
>>
>>
>> rjw@sisk.pl changed:
>>
>>            What    |Removed                     |Added
>> ----------------------------------------------------------------------------
>>              Status|NEW                         |REJECTED
>>          Resolution|                            |UNREPRODUCIBLE
>>
>>
>>
>>
>> ------- Comment #2 from rjw@sisk.pl  2008-03-28 15:35 -------
>> Handled-By : Mark Lord <lkml@rtr.ca>
>> References : http://lkml.org/lkml/2008/3/28/346
>>
>> Mark said:
>>
>> "Also, for now it seems to be "resolved" via a seemingly-unrelated
>> change in the .config file on that machine.  If it dies again,
>> I'll re-post and investigate further."
> ..
>
> Just happened again.  The machine resumed from RAM with no functioning USB.
> Still running the exact same 2.6.25-rc7 kernel as before, with the RTC conflict fixed.
>
> WTF?

>3GB of RAM? Try iommu=soft.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
