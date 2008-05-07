Return-Path: <linux-kernel-owner+w=401wt.eu-S933669AbYEGW2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669AbYEGW2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759064AbYEGW1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:27:55 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:50876 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761371AbYEGW1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:27:53 -0400
Message-ID: <48222CDE.60408@krogh.cc>
Date: Thu, 08 May 2008 00:27:42 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: "Randy.Dunlap" <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or directory".
References: <4819E316.7000607@krogh.cc> <481ACEC4.2040205@krogh.cc>	 <481B3115.30705@krogh.cc>	 <2c0942db0805020847q2fdc0480m3eb892bf2bd0b3a@mail.gmail.com>	 <481B70F9.6000201@krogh.cc> <481F4728.9050100@krogh.cc>	 <Pine.LNX.4.64.0805051050350.27703@shark.he.net>	 <481F49C0.4080001@krogh.cc>	 <2c0942db0805051121r47cc97d2jb71cc8ab9eaa7981@mail.gmail.com>	 <481F51F0.4000408@krogh.cc> <2c0942db0805051154q63a18bcfhce8a30d4a663ea3f@mail.gmail.com> <4822166F.50002@krogh.cc>
In-Reply-To: <4822166F.50002@krogh.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Krogh wrote:
> Both servers are 16 cores. The problem wasn't there on a different 
> server with only 2 cores. (or I didn't run into it).
> 
> The 3 setups above has both been tested with a 2.6.22-14-server and 
> 2.6.24-17-server (towards the iscsi volume).

I can confirm that the problem persists on a 2.6.25.2 kernel.

-- 
Jesper
