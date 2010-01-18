Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137Ab0ARRkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0ARRkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992Ab0ARRkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:40:05 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:37215 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab0ARRkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:40:04 -0500
MIME-Version: 1.0
In-Reply-To: <4B503422.60209@monstr.eu>
References: <4B4DE58D.10008@petalogix.com> <1263434836.724.317.camel@pasglop> 
	<4B503422.60209@monstr.eu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 18 Jan 2010 10:39:43 -0700
X-Google-Sender-Auth: c157e423e91356c2
Message-ID: <fa686aa41001180939m7a1f60eat208e548911c3c7a5@mail.gmail.com>
Subject: Re: xilinx-pci driver and pci in general
To: monstr@monstr.eu
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       michal.simek@petalogix.com, Arnd Bergmann <arnd@arndb.de>,
       thunderbird2k@gmx.net, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, John Williams <john.williams@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 2:23 AM, Michal Simek <monstr@monstr.eu> wrote:
> Benjamin Herrenschmidt wrote:
>> On Wed, 2010-01-13 at 16:23 +0100, Michal Simek wrote:
>>> Thanks for this early discuss. I would like to hear your opinion and then
>>> I will choose solution how to add our pci support to mainline.
>
> I will keep you informed but I see that I will add that part of code to
> mainline and then we look at consolidation work.

As mentioned in previous email, please do it the other way around.  It
may seem like more work to do so, but it is less work in the long
term.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
