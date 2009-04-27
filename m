Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZD0KyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZD0KyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZD0KyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:54:16 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37670 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbZD0KyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:54:15 -0400
Message-ID: <49F58ED3.20207@monstr.eu>
Date: Mon, 27 Apr 2009 12:54:11 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 01/30] microblaze_mmu_v1: Makefiles
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu> <1240821139-7247-2-git-send-email-monstr@monstr.eu> <200904271250.26725.arnd@arndb.de>
In-Reply-To: <200904271250.26725.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 27 April 2009, monstr@monstr.eu wrote:
>> From: Michal Simek <monstr@monstr.eu>
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> ---
>>  arch/microblaze/Makefile        |    4 ++++
>>  arch/microblaze/boot/Makefile   |    2 ++
>>  arch/microblaze/kernel/Makefile |    1 +
>>  arch/microblaze/lib/Makefile    |    3 ++-
>>  arch/microblaze/mm/Makefile     |    2 ++
>>  5 files changed, 11 insertions(+), 1 deletions(-)
> 
> It would be nice to keep the Makefile and Kconfig changes together with
> the files they are referring to, otherwise you risk getting an
> unbuildable source tree in the middle of a git-bisect.

make sense to me too -> I'll move Makefile to the end of set (in next version).

Thanks,
Michal
> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
