Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbZEXIiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbZEXIiE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 04:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbZEXIhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 04:37:55 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:46780 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbZEXIhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 04:37:54 -0400
Subject: Re: a couple quick kernel questions
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Tyler Littlefield <tyler@tysdomain.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <75608D7C7FD141D1B20D3AC37A6C77A3@tdsdev>
References: <75608D7C7FD141D1B20D3AC37A6C77A3@tdsdev>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 May 2009 10:38:39 +0200
Message-Id: <1243154319.16741.38.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lør, 23 05 2009 kl. 17:14 -0600, skrev Tyler Littlefield:
> Hello all,
> My name is tyler; I'm new to the list, and new to kernel development.
> I'd like to find a way I can help out, though I don't have huge servers or a 
> bunch of hardware to build and test drivers on.
> Is there a position somewhere where I can learn, and contribute something?
> 
> Also, my kernel modules is about 75 mb. I'm trying to figure out if there's 
> a place that describes all the config options so I can easily go through and 
> choose what I want. 75 mb isn't bad, but I'd rather not be using the extra 
> overhead, especially if I don't need it.

Use make menuconfig or make config and read the help text for the
various options.


Simon Holm Thøgersen

