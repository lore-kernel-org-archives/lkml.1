Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbXHZKJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbXHZKJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 06:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbXHZKJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 06:09:40 -0400
Received: from smtp21.orange.fr ([80.12.242.48]:7719 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbXHZKJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 06:09:39 -0400
X-ME-UUID: 20070826100938888.15AAA1C00082@mwinf2118.orange.fr
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: USB Key light on/off state depending on mount
MIME-Version: 1.0
Date: Sun, 26 Aug 2007 12:10:32 +0200
From: Xavier Bestel <xavier.bestel@free.fr>
Cc: Josh Boyer <jwboyer@gmail.com>, Casey Dahlin <cjdahlin@ncsu.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.60.0708252116580.3809@poirot.grange>
References: <Pine.LNX.4.60.0708252116580.3809@poirot.grange>
Message-ID: <c2e16c522b1482448b6cc871611625fd@awak.dyndns.org>
User-Agent: RoundCube Webmail/0.1-rc1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




On Sat, 25 Aug 2007 21:26:09 +0200 (CEST), Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Fri, 24 Aug 2007, Josh Boyer wrote:
> 
>> On 8/24/07, Casey Dahlin <cjdahlin@ncsu.edu> wrote:
>> > Most USB keys nowadays have a small LED somewhere inside of them that
>> > lights up when they are plugged in. On a windows box, the key is lit
> up
>> > whenever it is mounted, and as soon as it is unmounted it turns off,
>> > giving a handy physical indicator that the key is safe to remove. On
>> > linux, the light is simply on whenever the key is plugged in.

Windows powers off the USB device on unmount, whereas linus does not.
I think the problem may lie in HAL.

        Xav


