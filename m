Return-Path: <linux-kernel-owner+w=401wt.eu-S932201Ab0AFNqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab0AFNqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 08:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932139Ab0AFNqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 08:46:11 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:50318 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab0AFNqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 08:46:10 -0500
Message-ID: <4B4493F5.9010308@pardus.org.tr>
Date: Wed, 06 Jan 2010 15:45:25 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (X11/20071115)
MIME-Version: 1.0
To: Hui Zhu <teawater@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>, Matthew Wilcox <willy@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix markup_oops.pl get error in x86
References: <daef60381001060123vbb09aecy7943d72fcb8278a@mail.gmail.com>
In-Reply-To: <daef60381001060123vbb09aecy7943d72fcb8278a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hui Zhu wrote On 06-01-2010 11:23:
> Hello,
> 
> When I try to use markup_oops.pl in x86, I always get:

I already mentioned that but wasn't able to get attention, and yes the current code doesn't work,

http://lkml.indiana.edu/hypermail/linux/kernel/0908.0/02222.html
