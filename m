Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab0BDT0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:26:33 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:34459 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab0BDT0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:26:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=V6UCKM9ExNslUH9pwQeu7LqvRLdOAPM5RJQ0driKTUQTM60jSWA2xEjH925pphzLWt
         tn0iOtuQxx4WH7BMjUAYgCXnCQ5/uuyzIdykJMybw/BBDpvdY2wxMqa0QQusAa/AqIus
         hEsYykV/6DSBKarQnMdHik5cu8PgwSjUUfnuY=
MIME-Version: 1.0
In-Reply-To: <4B6B193D.4060106@gmail.com>
References: <4B6B193D.4060106@gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 4 Feb 2010 14:26:10 -0500
Message-ID: <3e8340491002041126l44bb28a7u8f427f0f5c05e57e@mail.gmail.com>
Subject: Re: Intercepting system calls
To: Oleg Kutkov <elenbert@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 2:00 PM, Oleg Kutkov <elenbert@gmail.com> wrote:
> Hello.
> Maybe this question is often, but all post i found is too old and some
> things is wrong...
> So, i need to intercept some system calls (socket calls) and make my own
> handler.
> Is there legal, correct and clean way to do it, without hacking system call
> table ?
> Thank.

Why do you need to do this? There may be a better way than overriding syscalls.
