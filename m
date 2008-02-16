Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbYBPNF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbYBPNF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 08:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYBPNFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 08:05:14 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:36021 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYBPNFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 08:05:13 -0500
Message-ID: <47B6DF8C.7030106@davidnewall.com>
Date: Sat, 16 Feb 2008 23:35:16 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Stephan Rose <stephan@eciinternational.de>
CC: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: PL2303 Driver missing support for USB to Serial Cable
References: <1203001060.8420.11.camel@software> <47B6DC7A.3040308@gmail.com>
In-Reply-To: <47B6DC7A.3040308@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan,

Jiri Slaby wrote:
> On 02/14/2008 03:57 PM, Stephan Rose wrote:
>> I recently purchased a USB->Com Port serial cable from Radio Shack
>> (Model number 26-183) which did no seem to want to work. After looking
>> into it I discovered that it is based on the Prolific chipset using the
>> PL2303 driver.
>
> Well, would you mind creating, testing and posting a patch?


You needn't bother.  As far as I'm concerned, what you sent is
sufficient and, as I am currently working on the pl2303 driver, you can
rest assured that it will be included in the patch that I send.

Regards,

David
