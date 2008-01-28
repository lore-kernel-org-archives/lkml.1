Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbYA1AmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbYA1AmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 19:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYA1AmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 19:42:15 -0500
Received: from eazy.amigager.de ([213.239.192.238]:42042 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbYA1AmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 19:42:14 -0500
Date: Mon, 28 Jan 2008 01:42:19 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Troubles waking up from suspend (S3) - how to debug?
Message-ID: <20080128004219.GA10726@dose.home.local>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200801271842.38007.bonbons@linux-vserver.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801271842.38007.bonbons@linux-vserver.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 18:42:37 +0100, Bruno Prémont wrote:
> I'm currently trying out suspend (S3) on a few machines but none of them wakes 
> up completely/properly (I have a few more hosts I'm planning to try suspend 
> on once I can get useful information out of those not waking up properly).

[...]

> Acer Travelmate 660 laptop (i855GM based):
>   Laptop suspends as expected but hangs while waking up.

You might try this:

http://tikei.de/suspend-to-ram-debug

Regards,
Tino
