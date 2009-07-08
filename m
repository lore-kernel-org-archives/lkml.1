Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbZGHCue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbZGHCue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 22:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbZGHCuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 22:50:24 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:37697 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbZGHCuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 22:50:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qrTBa2Qo4GnGSs03eNBg79AZoJVU6x/oqgvizMqAowdvoPniqfrAAmlRQ5+CKfr38o
         VMAOGb7vEZLg+7xERnEWqmrAsaKfRyAt5/IOtmPLG+zwnY1v2qrKzs73uXvNMfMC1f8Y
         wqAQIh0S9RvnQ1/ZEQqoemcvNqNQh0s4cHQlc=
MIME-Version: 1.0
In-Reply-To: <200907080232.04551.elendil@planet.nl>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
	 <dWkuWjWDsSB.A.6tE.d0oUKB@chimera>
	 <200907080232.04551.elendil@planet.nl>
Date: Wed, 8 Jul 2009 12:50:22 +1000
Message-ID: <21d7e9970907071950n27979df6j44444edd8528a598@mail.gmail.com>
Subject: Re: [Bug #13667] drm: display arifacts when X.Org is stopped
From: Dave Airlie <airlied@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 8, 2009 at 10:32 AM, Frans Pop<elendil@planet.nl> wrote:
> On Tuesday 07 July 2009, Rafael J. Wysocki wrote:
>> The following bug entry is on the current list of known regressions
>> from 2.6.30.  Please verify if it still should be listed and let me
>> know (either way).
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13667
>> Subject       : drm: display arifacts when X.Org is stopped
>> Submitter     : Frans Pop <elendil@planet.nl>
>> Date          : 2009-06-27 18:52 (10 days old)
>> References    : http://lkml.org/lkml/2009/6/27/105
>
> Problem is still there with -rc2. Dave said he'd try to reproduce, but
> I've not heard back from him yet.
>

I have my 2510p, I just have to get a PSU to run it, at least I hope its just
the PSU.

Don't suppose you have a 32-bit install you could also test with?

Hopefully I can reproduce it on my box locally, otherwise its really
messy dealing with 2 drivers smashing on the same hw.

btw you get any wierd text mode issues without vesafb?

Dave.
