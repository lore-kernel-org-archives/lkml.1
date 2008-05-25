Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYEYE4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYEYE4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 00:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYEYE40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 00:56:26 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:43316 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbYEYE40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 00:56:26 -0400
Message-ID: <fa686aa40805242156p132ef760u30f5151107ecb1c0@mail.gmail.com>
Date: Sat, 24 May 2008 22:56:25 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Cc: "Jochen Friedrich" <jochen@scram.de>, fabrizio.garetto@gmail.com,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
In-Reply-To: <200805241045.47448.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <48384D13.6010608@scram.de>
	 <fa686aa40805241033x128c30b0v826717cc879a712e@mail.gmail.com>
	 <200805241045.47448.david-b@pacbell.net>
X-Google-Sender-Auth: 0efaad1fd428aac0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 11:45 AM, David Brownell <david-b@pacbell.net> wrote:
> On Saturday 24 May 2008, Grant Likely wrote:
>> > Isn't the same true for drivers/of/gpio.c or drivers/of/of_i2c.c, as well?
>>
>> I would argue 'yes!'
>
> ... all the more reason to have the SPI glue go there too,
> matching the ACPI/PCI precedent as well as those others!

Alright; I give!  I'll put it in drivers/of.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
