Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbYIRSGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbYIRSGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbYIRSGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:06:07 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:65316 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235AbYIRSGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:06:06 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ACPI idea: override max. frequency
Date: Fri, 19 Sep 2008 04:05:40 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <ku55d4pjvn5avnisj951vtcics1qen8a90@4ax.com>
References: <20080918153032.GU4323@vanheusden.com>
In-Reply-To: <20080918153032.GU4323@vanheusden.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 17:30:32 +0200, Folkert van Heusden <folkert@vanheusden.com> wrote:

>Hi,
>
>The bios of the motherboard in my pc (a Gigabyte 965G-DS3) says the
>processor can go no faster than 2.133GHz while in reality this is 2.6GHz
>(it is an Intel(R) Core(TM)2 Quad CPU Q9450 @ 2.66GHz). No newer bios is
>available so I was thinking: maybe an override switch can be added?
>Losing 0.5GHz is a bit of a waste.

Nothing to do with the kernel, your mobo is 1066MHz and the Q9450 is 
1333Mhz bus, you could have bought a Q6700 for 2.66GHz on 1066MHz bus 
operation.

Grant.
