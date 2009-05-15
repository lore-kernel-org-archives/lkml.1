Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbZEOSvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbZEOSvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbZEOSum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:50:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753943AbZEOSul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:50:41 -0400
Date: Fri, 15 May 2009 11:49:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
       Felix Fietkau <nbd@openwrt.org>, davem@davemloft.net
Subject: Re: [PATCH 1/2] mac80211: minstrel, fix memory corruption
In-Reply-To: <20090515183319.GF2773@tuxdriver.com>
Message-ID: <alpine.LFD.2.01.0905151147520.3343@localhost.localdomain>
References: <1241453096-8517-1-git-send-email-jirislaby@gmail.com> <20090515182131.GA6439@fancy-poultry.org> <20090515183319.GF2773@tuxdriver.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 May 2009, John W. Linville wrote:
>
> Unfortunately, I think Dave might have limited availability right now...

Yeah, I think he's on some Alaskan cruise.

Should I just pull directly from you this time?

		Linus
