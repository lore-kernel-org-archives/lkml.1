Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab0CHTth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:49:37 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:54836 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab0CHTtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:49:31 -0500
X-Auth-Info: sppUoXzwvd3m9sukbPkLJBKlRrSPqfk4e6RLn6BqczY=
Message-ID: <4B955460.4030904@grandegger.com>
Date: Mon, 08 Mar 2010 20:47:44 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: socketcan-core@lists.berlios.de,
       Urs Thuermann <urs.thuermann@volkswagen.de>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>,
       linux-kernel@vger.kernel.org, Barry Song <barry.song@analog.com>,
       stable@kernel.org, stable-review@kernel.org
Subject: Re: [PATCH] can: fix bfin_can build error after alloc_candev() change
References: <1268066144-26830-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1268066144-26830-1-git-send-email-vapier@gentoo.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> From: Barry Song <barry.song@analog.com>
> 
> Looks like commit a6e4bc530403 didn't include updates to drivers so the
> Blackfin CAN driver fails to build now.
> 
> Signed-off-by: Barry Song <barry.song@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Oops, it did include updates for the drivers but at that time the bfin
driver was not yet mainline but somewhere in the patch pipeline.

Acked-by: Wolfgang Grandegger <wg@grandegger.com>
