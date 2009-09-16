Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbZIPMcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbZIPMcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbZIPMcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:32:11 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41979 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780AbZIPMcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:32:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=N0iNBEin7bwui43k0KHy8DnlrHspG4cwGRgNiOsRjMGs1mPaylyOM8wylNUXdv6hJz
         7pkWUtckROF0JnGeqnWwnPDYP0Og8wS85jxIak+V55Qc1EOETvRyQW54Aq+Fyu/zpjwG
         1Qh6lWAUWUJe69uWGjVcN7JYdEI9PN6GCZH98=
MIME-Version: 1.0
In-Reply-To: <194f62550909090403x16e61cc1g3a23593085de0b@mail.gmail.com>
References: <194f62550909090403x16e61cc1g3a23593085de0b@mail.gmail.com>
Date: Wed, 16 Sep 2009 08:32:12 -0400
Message-ID: <194f62550909160532q248cb45coee639a2da10292a@mail.gmail.com>
Subject: Re: Howto switch off ext4's delayed allocation?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just happend again to me.
After the intel driver crashed my system, the source-file I was
working on was empty. Fourtunatly eclipse has a history-log.

Isn't there a way to switch off the more "dangerous" optimizations in ext4?
I already searched howto do this, but from what I've seen there was
only discussion about providing a switch for disabling delayed
allocation, but it was never done?

Thanks, Clemens

2009/9/9 Clemens Eisserer <linuxhippy@gmail.com>:
> Hi,
>
> Every since switching to ext4, I suffer fromt he empty files problem
> after crashes.
> Since GEM/KMS was included, as well as the changes to the usb-serial
> subsystem I experience crashes from time to time.
>
> As far as I understand this is caused by delayed allocation.
> I really enjoy the performance benefits of ext4, and I know
> applications should be fixed - but having this problem seen with so
> many apps I doubt it will ever happen. (Kwrite, bash itself, umtsmon,
> ...).
>
> Is there any way to disable delayed allocation? (running 2.6.31rc8)
>
> Thank you in advance, Clemens
>
