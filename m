Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbZC1JPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbZC1JPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 05:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZC1JPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 05:15:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59269 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZC1JPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 05:15:01 -0400
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Clocksource tsc unstable
From: Andi Kleen <andi@firstfloor.org>
References: <a8e1da0903272335scc5ee66sdaaa170d982dc116@mail.gmail.com>
Date: Sat, 28 Mar 2009 10:14:56 +0100
In-Reply-To: <a8e1da0903272335scc5ee66sdaaa170d982dc116@mail.gmail.com> (Dave Young's message of "Sat, 28 Mar 2009 14:35:56 +0800")
Message-ID: <87tz5e6mb3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young <hidave.darkstar@gmail.com> writes:

> Hi,
>
> My laptop is dell e5400 with  intel core 2 duo 7250, kernel version
> 2.6.29, dmesg report tsc unstable, anyone can help to see?

It's expected behaviour for core 2 duo with C3 states.

-Andi

