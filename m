Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0BAMtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 07:49:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47535
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259Ab0BAMs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 07:48:59 -0500
Date: Mon, 01 Feb 2010 04:49:11 -0800 (PST)
Message-Id: <20100201.044911.15611947.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: xtfeng@gmail.com, rjw@sisk.pl, htd@fancy-poultry.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [Bug #15196] kmem_cache_create: duplicate cache ccid2_h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100201115518.GA25094@hmsreliant.think-freely.org>
References: <7b6bb4a51001311930i7d72f60dj3b15ca3e1a715607@mail.gmail.com>
	<20100131.232050.266652459.davem@davemloft.net>
	<20100201115518.GA25094@hmsreliant.think-freely.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 1 Feb 2010 06:55:18 -0500

> He claims this dependency is deliberate and requires, to which I agree, but he
> would seem to fix that by making the dccp_probe module error out in the event
> that dccp wasn't loaded.  Why bother with that?

Neil, please get into the thread Gerrit started so he can see your
questions and responses too.

I already chided him for not CC:'ing you in the first place, guys
stop hiding from eachother :-)
