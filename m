Return-Path: <linux-kernel-owner+w=401wt.eu-S1763067AbZCYQLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763067AbZCYQLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759643AbZCYQLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:11:04 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47823 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077AbZCYQLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:11:01 -0400
Message-ID: <49CA578F.7010907@monstr.eu>
Date: Wed, 25 Mar 2009 17:10:55 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 01/57] microblaze_v7: Kconfig patches
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu> <200903251642.40442.arnd@arndb.de>
In-Reply-To: <200903251642.40442.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 18 March 2009, monstr@monstr.eu wrote:
>> From: Michal Simek <monstr@monstr.eu>
>>
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> ---
>>  arch/microblaze/Kconfig                       |  136 +++++++++++++++++++++++++
>>  arch/microblaze/Kconfig.debug                 |   26 +++++
>>  arch/microblaze/platform/Kconfig.platform     |   85 +++++++++++++++
>>  arch/microblaze/platform/generic/Kconfig.auto |   62 +++++++++++
>>  4 files changed, 309 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/microblaze/Kconfig
>>  create mode 100644 arch/microblaze/Kconfig.debug
>>  create mode 100644 arch/microblaze/platform/Kconfig.platform
>>  create mode 100644 arch/microblaze/platform/generic/Kconfig.auto
> 
> As a general rule for future updates, you should make sure that
> the order of your patches is so that you don't get a broken
> version in the middle. In your current series, it's not important,
> because nothing works really until all your patches are in there.

Thanks for your advice.
I am trying to do in all project where I work.

Thanks,
Michal


> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
