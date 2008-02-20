Return-Path: <linux-kernel-owner+w=401wt.eu-S932841AbYBTQ46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841AbYBTQ46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762038AbYBTQ4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:56:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58075 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbYBTQ4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:56:20 -0500
Message-ID: <47BC5C17.3070507@firstfloor.org>
Date: Wed, 20 Feb 2008 17:57:59 +0100
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: balbir@linux.vnet.ibm.com, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller
 in Kconfig
References: <20080220122338.GA4352@basil.nowhere.org>	<47BC2275.4060900@linux.vnet.ibm.com> <18364.16552.455371.242369@stoffel.org>
In-Reply-To: <18364.16552.455371.242369@stoffel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I know this is a pedantic comment, but why the heck is it called such
> a generic term as "Memory Controller" which doesn't give any
> indication of what it does.

I don't think it's pedantic. I would agree with you in fact
that the Kconfig description is not very helpful, even with
my warning added.

-Andi
