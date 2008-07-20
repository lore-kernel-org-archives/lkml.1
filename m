Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbYGTQO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbYGTQO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 12:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbYGTQOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 12:14:20 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4173 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbYGTQOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 12:14:19 -0400
Message-ID: <48836457.2050302@xs4all.nl>
Date: Sun, 20 Jul 2008 18:14:15 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: kernel: TD structure error TDindex=e
References: <48835302.1090708@xs4all.nl> <20080720160812.GA23652@electric-eye.fr.zoreil.com>
In-Reply-To: <20080720160812.GA23652@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Udo van den Heuvel <udovdh@xs4all.nl> :
> [...]
>> 16:41:09 recorder kernel: TD structure error TDindex=e
(...)
>> How can I avoid/fix/etc this situation ?
> 
> Can you apply the patch below to get some more information ?

Will do, will look for an earliest opportinuty to boot the machine with
the patched kernel.

> May I assume that it does not count as a regression ?

Can't confirm/deny.
It has 'hung' before.
