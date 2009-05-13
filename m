Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbZEMSnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbZEMSnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 14:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760150AbZEMSnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 14:43:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38329 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759421AbZEMSnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 14:43:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A0B14B9.6050101@s5r6.in-berlin.de>
Date: Wed, 13 May 2009 20:43:05 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: "Mikko C." <mikko.cal@gmail.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: reiserfs regression since rc3?]
References: <4A083302.2080401@gmail.com>
In-Reply-To: <4A083302.2080401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikko C. wrote:
> This is still valid with 2.6.30-rc5
...
(when mounting a reiserfs volume)
> WARNING: at fs/namei.c:1251 lookup_one_len+0xda/0xf0()
...

Al Viro wrote that he has fixes queued up:
http://lkml.org/lkml/2009/5/9/97

It looks to me as if Linus merged these already but I haven't updated 
yet for testing.
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
