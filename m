Return-Path: <linux-kernel-owner+w=401wt.eu-S1764435AbYBTS2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764435AbYBTS2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760009AbYBTS2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:28:07 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58405 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760300AbYBTS2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:28:04 -0500
Date: Wed, 20 Feb 2008 19:28:03 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, John Stoffel <john@stoffel.org>,
       Andi Kleen <andi@firstfloor.org>, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller
 in Kconfig
In-Reply-To: <20080220181911.GA4760@ucw.cz>
Message-ID: <Pine.LNX.4.64.0802201927440.26109@fbirervta.pbzchgretzou.qr>
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com>
 <18364.16552.455371.242369@stoffel.org> <47BC4554.10304@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0802201647060.26109@fbirervta.pbzchgretzou.qr>
 <20080220181911.GA4760@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 20 2008 18:19, Pavel Machek wrote:
>> 
>> For ordinary desktop people, memory controller is what developers
>> know as MMU or sometimes even some other mysterious piece of silicon
>> inside the heavy box.
>
>Actually I'd guess 'memory controller' == 'DRAM controller' == part of
>northbridge that talks to DRAM.

Yeah that must have been it when Windows says it found a new controller
after changing the mainboard underneath.
