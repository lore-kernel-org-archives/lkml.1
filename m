Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYKCPOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYKCPOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbYKCPOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:14:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:24230 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391AbYKCPOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:14:24 -0500
Message-ID: <ac3eb2510811030714k55afc475h6edf3e97b8a50888@mail.gmail.com>
Date: Mon, 3 Nov 2008 16:14:22 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: thinkpad_acpi: struct device - replace bus_id with dev_name(), dev_set_name()
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
In-Reply-To: <20081103145423.GE31078@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225330737.5970.96.camel@nga.site>
	 <20081103145423.GE31078@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2008 at 15:54, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Thu, 30 Oct 2008, Kay Sievers wrote:
>> From: Kay Sievers <kay.sievers@vrfy.org>
>> Subject: thinkpad_acpi: struct device - replace bus_id with dev_name(), dev_set_name()
>>
>> CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
>> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
>
> Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
>
> Do you want me to push it to Len for merge through the acpi tree, or are
> you guys going to be handle it through another tree?

Would be nice if you can push it and it will show up in -next soon, so
we can check there what's still missing.

Thanks,
Kay
