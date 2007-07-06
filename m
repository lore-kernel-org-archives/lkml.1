Return-Path: <linux-kernel-owner+w=401wt.eu-S1763539AbXGFQM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763539AbXGFQM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 12:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbXGFQMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 12:12:16 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36271 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbXGFQMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 12:12:15 -0400
Message-ID: <468E69D8.20909@zytor.com>
Date: Fri, 06 Jul 2007 09:12:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Gautam Singaraju <gautam.singaraju@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: syscall macro fails upon compilation
References: <f8b2ccd40707051509tcbce704y3e5b114580069039@mail.gmail.com>	 <468D6D1F.4040008@zytor.com> <p73r6nl21fe.fsf@bingen.suse.de> <f8b2ccd40707060855o33f1db48v2139ed909e774066@mail.gmail.com>
In-Reply-To: <f8b2ccd40707060855o33f1db48v2139ed909e774066@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gautam Singaraju wrote:
> I am surprised that syscalls have been removed. Anyway, I plan to
> write a device node with read and write functions just so that I can
> call a method from a user space. What are my other choices?

man syscall

	-hpa
