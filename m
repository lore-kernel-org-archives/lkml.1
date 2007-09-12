Return-Path: <linux-kernel-owner+w=401wt.eu-S969534AbXILOdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969534AbXILOdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967176AbXILOdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:33:17 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:6803 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967091AbXILOdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:33:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FQLuX6iJkMlHmsjKVQuSYCpsj0wSlQ5PIAXJpKOy8lfSk2NecM48ajDTKa+VkbJZCM6lnI/cDZhNQmzsFGwwQX1zkOfKC2J5d/y/p+8aUJ0ilA9ulJe/qPOVMb1jOLgofcdLxE2GkA7X05VzUp9T8+TTEIsyqf0ASwNEjs3401g=
Message-ID: <625fc13d0709120733w32878f94oca2034f12f47c30c@mail.gmail.com>
Date: Wed, 12 Sep 2007 09:33:12 -0500
From: "Josh Boyer" <jwboyer@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: 2.6.23-rc6-git1 -- termios *_1 compile failures on powerpc
Cc: "Alan Cox" <alan@redhat.com>, "David Miller" <davem@davemloft.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Mel Gorman" <mel@csn.ul.ie>
In-Reply-To: <20070912115823.GG4835@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070912115823.GG4835@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/07, Andy Whitcroft <apw@shadowen.org> wrote:
> The following commit just hit mainline and all my powerpc test boxes are
> failing during compilation:
>
>         commit f629307c857c030d5a3dd777fee37c8bb395e171
>         tty: termios locking functions break with new termios type

I think this is already being discussed on the linuxppc-dev list.

josh
