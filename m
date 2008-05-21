Return-Path: <linux-kernel-owner+w=401wt.eu-S1765859AbYEUJiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765859AbYEUJiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYEUJiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:38:05 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44849 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbYEUJiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:38:04 -0400
Date: Wed, 21 May 2008 11:38:01 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Shawn Starr <shawn.starr@rogers.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Modern 2.6 kernels - Notification for changing hostname from
 proc/sys/kernel/hostname ?
In-Reply-To: <200805191605.32484.shawn.starr@rogers.com>
Message-ID: <alpine.LNX.1.10.0805211137160.15136@fbirervta.pbzchgretzou.qr>
References: <200805191316.12424.shawn.starr@rogers.com> <20080519204535.GA23629@martell.zuzino.mipt.ru> <200805191605.32484.shawn.starr@rogers.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-05-19 22:05, Shawn Starr wrote:
>>
>> Why does it want to know if and when hostname changes?
>>
>Well, It's for keeping track of the X session, if the hostname changes things 
>go bad.

Then these should be resolved. Sometimes, even setting just the time
with ntpdate makes X go blank for a few seconds, or even exit.

