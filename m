Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbXGIKuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbXGIKuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbXGIKug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:50:36 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:53948 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbXGIKuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:50:35 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: mikie <mikie.pl@gmail.com>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Date: Mon, 9 Jul 2007 12:50:35 +0200
User-Agent: KMail/1.9.7
Cc: "Indan Zupancic" <indan@nul.nu>, linux-kernel@vger.kernel.org
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com> <58019.81.207.0.53.1183749400.squirrel@secure.samage.net> <ca35ce500707090149x78a424f6t9d687893c0d657f6@mail.gmail.com>
In-Reply-To: <ca35ce500707090149x78a424f6t9d687893c0d657f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707091250.37670.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On my system the /proc/sys/kernel/hotplug points to /sbin/hotplug.
> I copied your script to /sbin/hotplug and also added simple logging,
> so I can see whenever the script is being started. It turns out that
> the script is not started at all by the kernel...

did you turn hotplug on in your kernel's .config?

Ciao,

D.
