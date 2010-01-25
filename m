Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157Ab0AYJ0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0AYJ0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 04:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776Ab0AYJ0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 04:26:51 -0500
Received: from lucidpixels.com ([75.144.35.66]:34158 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab0AYJ0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 04:26:49 -0500
Date: Mon, 25 Jan 2010 04:26:47 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Valdis.Kletnieks@vt.edu
cc: linux-kernel@vger.kernel.org
Subject: Re: High pitch noise when ACPI processor module is loaded.
In-Reply-To: <9883.1264397678@localhost>
Message-ID: <alpine.DEB.2.00.1001250424540.4502@p34.internal.lan>
References: <alpine.DEB.2.00.1001231046080.1064@p34.internal.lan> <9883.1264397678@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Jan 2010, Valdis.Kletnieks@vt.edu wrote:

> On Sat, 23 Jan 2010 10:48:50 EST, Justin Piszcz said:
>> Hi,
>>
>> Linux:
>> When I do not load the ACPI processor module, there is no high pitch
>> noise.  When I load the ACPI processor module (so I can utilize Turbo
>> Boost), Linux makes the system emit a high pitch noise.
>
> Sounds like singing capacitors.
>
> http://lwn.net/Articles/145973/ - and see the last 2 comments.
>
>
>

Hi,

I think something else may be wrong?

I switched my kernel config to 100 HZ and the problem persists.

So the question remains, is it possible to utilize turbo boost (in Linux)
without the high pitch noise from the ACPI processor module?

Again, when the module is not loaded, no matter what HZ, there is no high 
pitch noise.

Justin.

