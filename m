Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966548Ab0BZXcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 18:32:18 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54942 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759513Ab0BZXcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 18:32:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qS6a71a+X5ar+ep699kH8lBh4Q9t8Jhtc5bN2Q1y2qmy22iUZLTjd2v/IA8OC3il/1
         3DhZQDnsKMXNGqjBgf8/HqnZ/GkS7cwSZ9yFYs0FDb+iaUMtzSeBKidn2B+NuSCvwx9d
         4jYdWwvTixTPeu5Urx7NeU2q5Orz0WlDUeqR4=
MIME-Version: 1.0
In-Reply-To: <20100226160716.1bd4e342@droptest.queued.net>
References: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
	 <20100224184505.1d8d3380@droptest.queued.net>
	 <808c8e9d1002260947k281782al889db51e20073648@mail.gmail.com>
	 <20100226160716.1bd4e342@droptest.queued.net>
Date: Fri, 26 Feb 2010 17:32:15 -0600
Message-ID: <808c8e9d1002261532v447d62dfna61d0b19493b6551@mail.gmail.com>
Subject: Re: [PATCH] OLPC: ALSA: fix cs5535audio's MIC GPIO to enable input
From: Ben Gardner <gardner.ben@gmail.com>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm working on a gpiolib patch that will combine gpio_direction_output
>> and gpio_direction_input into one function.  That would enable the
>> above driver to be 'obviously correct'.
>
> Cool.  I'm happy to help convert drivers if you want the help.

I'm not one to turn down help.
Lets see how the proposed changes I just sent off are received and go
from there.

Ben
