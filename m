Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbYEOKsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbYEOKsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 06:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYEOKsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 06:48:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52266 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbYEOKsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 06:48:08 -0400
Message-ID: <482C14E4.9050201@firstfloor.org>
Date: Thu, 15 May 2008 12:48:04 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, muli@il.ibm.com,
       alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
References: <87y76cym96.fsf@basil.nowhere.org>	<20080515181619R.tomof@acm.org>	<482C02A4.80101@firstfloor.org> <20080515184126O.tomof@acm.org>
In-Reply-To: <20080515184126O.tomof@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I thought that KVM people want to do it per device (in the first
> case). So with my patchse, they can replace the dma_ops pointer in
> dev_archdata with what they want.

But where would they save the original pointer?

-Andi

