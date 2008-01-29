Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbYA2XG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbYA2XG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbYA2XGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:06:52 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:38341 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbYA2XGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:06:51 -0500
Date: Wed, 30 Jan 2008 00:06:50 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Pavel Roskin <proski@gnu.org>, linux-kernel@vger.kernel.org,
       Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>, rms@gnu.org
Subject: Re: ndiswrapper and GPL-only symbols redux
In-Reply-To: <20080129225701.GS8767@does.not.exist>
Message-ID: <Pine.LNX.4.64.0801300004431.14907@fbirervta.pbzchgretzou.qr>
References: <1201641765.18773.35.camel@dv> <20080129225701.GS8767@does.not.exist>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30 2008 00:57, Adrian Bunk wrote:
>> Hello!
>> 
>> It have come to my attention that a patch has been committed to the
>> kernel with the explicit purpose of tainting ndiswrapper - the kernel
>> module allowing Windows NDIS drivers for Ethernet and Wireless cards to
>> be used by the kernel.
>>...
>> Just to reiterate some points from the old discussion:
>>...
>> - no copyright violation is involved, as Windows drivers are not derived
>> from Linux sources
>>...
>
>It is interesting that someone posting with an @gnu.org address claims
>that dynamic linking of not GPLv2 compatible code into GPLv2 code was
>not a copyright violation.
>
How about you see this as syscall linkage or pipe linkage^2 instead?
Linux and GNU, respectively, allow these.


^2  gplprogram <input.txt | proprietaryprogram >output.txt
