Return-Path: <linux-kernel-owner+w=401wt.eu-S1761621AbYDZTGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761621AbYDZTGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761484AbYDZTFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:05:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33268 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758998AbYDZTFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:05:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48137CF0.7090608@s5r6.in-berlin.de>
Date: Sat, 26 Apr 2008 21:05:20 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: Re: [RFC git pull] "big box" x86 changes
References: <20080426185516.GA32364@elte.hu>
In-Reply-To: <20080426185516.GA32364@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>       x86: fix k8-bus_64.c build

Is it not necessary to fold this into a previous patch, to keep the tree 
bisectable?
-- 
Stefan Richter
-=====-==--- -=-- ==-=-
http://arcgraph.de/sr/
