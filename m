Return-Path: <linux-kernel-owner+w=401wt.eu-S965751AbXAYKJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965751AbXAYKJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 05:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965756AbXAYKJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 05:09:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:62272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965751AbXAYKJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 05:09:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kyh3MYtB45voe9WOoRifgi5fA3CadY437RdBJkQvT+FhjA2VtBLdcK2tLmQd6Ll0lpkoKp5nDVEUYnoYHN6QhWedbNxKAMW3syWOo+gmLk5OeQwWv0SYw6Ki2PN/o5dQHXIsYbU+SYDVuSaMbn3A4l2DpPdRh0DncLL8ej0OSCE=
Message-ID: <8355959a0701250209q31bbbf77rca07b4efe46c1082@mail.gmail.com>
Date: Thu, 25 Jan 2007 15:39:52 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.20-rc6
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> It's been more than a week since -rc5, but I blame everybody (including
> me) being away for Linux.conf.au and then me waiting for a few days
> afterwards to let everybody sync up.
>
> So there it is, -rc6, hopefully the last -rc of the series.
>

It was a cool booting, have really enjoyed this.

I have one question which is open (seems ignored or missed by u guys).

migration_cost=33 for 2.6.20-rc5
migration_cost=159 for 2.6.20-rc6

What does this mean?


>                 Linus
>
~Akula2
