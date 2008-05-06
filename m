Return-Path: <linux-kernel-owner+w=401wt.eu-S934116AbYEFXWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116AbYEFXWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbYEFXWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:22:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:34966 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbYEFXWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:22:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TJ+q6NefGY4t/KuGCNKsYG/4FtLpYUiDQkICHyyvhrD6UDU5PqZS4UTlBanzLMoupkbiTDqRv/JRf3nxMr1UZtqeDLYXsEhiNK794CLIM2IBvUVV8eZJrxN4oQHQsfnhzo7smmhxjhRFDD6LNelKgxWK61or2zTyUeJmneMzdA8=
Message-ID: <c4e36d110805061622j7025b4f9ufb4f0d181351e16a@mail.gmail.com>
Date: Wed, 7 May 2008 01:22:11 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: WARNING: at arch/x86/kernel/genapic_64.c:86
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200805070041.55369.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110804220204h3043e526xee3966876355cde0@mail.gmail.com>
	 <200805070041.55369.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/7 Rafael J. Wysocki <rjw@sisk.pl>:
> On Tuesday, 22 of April 2008, Zdenek Kabelac wrote:
>  > Hello
>  >
>  > I've update to the current commit 2.6.25
>  > 8a81f2738f10ca817c975cec893aa58497e873b2
>
>  Does it still happen with the current -git?
>
>
>

The last day for this backtrace is from 2nd May in my kernel log.
So I guess it's been fixed in current git.

Zdenek
