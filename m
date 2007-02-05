Return-Path: <linux-kernel-owner+w=401wt.eu-S932261AbXBENAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbXBENAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932333AbXBENAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:00:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:63282 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbXBEM77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 07:59:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uD6IQFFwUWkdyQcokR1vzxMyG3oDpuu6BMkJJcCjsgxygmcqXHaECbuwXmzC57hLNFI0wEXNFNxV8tzk+/ZvdYWsMq9caTHW76/f0v24hYtp32VxTcvWVRwJPZ3QeQYFb2mKRcYwC5T6Ztnd5gqtr5gEkNk/FgHhcKv7aAD9y/c=
Message-ID: <6bffcb0e0702050459y692359ai67cbd4f93e11d06e@mail.gmail.com>
Date: Mon, 5 Feb 2007 13:59:56 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: v2.6.20-rt1, yum/rpm
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070205065636.GA1652@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070205065636.GA1652@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/02/07, Ingo Molnar <mingo@elte.hu> wrote:
> i have released the v2.6.20-rt1 kernel, which can be downloaded from the
> usual place:
>
>   http://redhat.com/~mingo/realtime-preempt/
>

It looks like a bug to me

BUG: MAX_LOCKDEP_ENTRIES too low!
turning off the locking correctness validator.

http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20-rt1/rt-dmesg
http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20-rt1/rt-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
