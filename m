Return-Path: <linux-kernel-owner+w=401wt.eu-S936527AbYEBTy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936527AbYEBTy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934040AbYEBTyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:54:09 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:52807 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934791AbYEBTyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:54:07 -0400
Message-ID: <481B714E.7050308@krogh.cc>
Date: Fri, 02 May 2008 21:53:50 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or directory".
References: <4819E316.7000607@krogh.cc>	 <20080501223938.921f7cd2.akpm@linux-foundation.org>	 <481ACEC4.2040205@krogh.cc> <481B3115.30705@krogh.cc>	 <2c0942db0805020847q2fdc0480m3eb892bf2bd0b3a@mail.gmail.com>	 <481B395E.5070505@krogh.cc> <2c0942db0805020945i2f46a41dl28cdcec25c9e2ac3@mail.gmail.com>
In-Reply-To: <2c0942db0805020945i2f46a41dl28cdcec25c9e2ac3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> Sorry for belaboring the point, but reading up-thread I see you ran
> both / and /troublefs one after the other, but you're saying you also
> ran them at the same time? If so, that would seem to conclusively rule
> out hardware overheating.

I've run up to 32 instances of the program at the same time. Both on the
/ volumes and the "trouble" volume. Only programs from the trouble
volume failed.

Jesper
-- 
Jesper
