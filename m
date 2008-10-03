Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYJCEoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYJCEoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 00:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYJCEoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 00:44:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44403 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbYJCEoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 00:44:05 -0400
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH] Block device for the ISS simulator
From: Andi Kleen <andi@firstfloor.org>
References: <20081003000904.0A812DDEEE@ozlabs.org>
Date: Fri, 03 Oct 2008 06:44:03 +0200
In-Reply-To: <20081003000904.0A812DDEEE@ozlabs.org> (Benjamin Herrenschmidt's message of "Fri, 03 Oct 2008 10:08:42 +1000")
Message-ID: <87tzbunv8s.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> The ISS simulator is a simple powerpc simulator used among other things
> for hardware bringup. It implements a simple memory mapped block device
> interface.

...
>
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-work/drivers/block/iss_blk.c	2008-09-23 11:12:03.000000000 +1000
> @@ -0,0 +1,365 @@
> +/*
> + * Simple block device for the ISS simulator
> + */

The first paragraph in your description above should be in this comment.

-Andi
