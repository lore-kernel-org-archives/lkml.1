Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYA3N2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYA3N2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbYA3N2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:28:38 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50107 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYA3N2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:28:37 -0500
Date: Wed, 30 Jan 2008 14:28:36 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Matti Linnanvuori <mattilinnanvuori@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ARP Bug?
In-Reply-To: <p73r6fz5u2b.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0801301427150.15249@fbirervta.pbzchgretzou.qr>
References: <67062.74127.qm@web52004.mail.re2.yahoo.com> <p73r6fz5u2b.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30 2008 14:20, Andi Kleen wrote:
>Matti Linnanvuori <mattilinnanvuori@yahoo.com> writes:
>>
>> ARP standard. I think it is RFC 826:
>> An Ethernet Address Resolution Protocol
>
>The correct standard in this case is RFC1122 and it actually
>offers two options for this: the so called strong end host model and the 
>weak end host model. Linux can be configured to be both. Default
>is the later.

By use of a bridge interface, yeah. Are there other ways to get the
strong end host model?
