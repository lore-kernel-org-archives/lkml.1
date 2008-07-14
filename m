Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbYGNUCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbYGNUCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 16:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbYGNUCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 16:02:32 -0400
Received: from gw.goop.org ([64.81.55.164]:53067 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378AbYGNUCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:02:31 -0400
Message-ID: <487BB0CA.6090306@goop.org>
Date: Mon, 14 Jul 2008 13:02:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
CC: NetDev <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26: iwl3945 failing to initialize wep, crypto modprobe failure?
References: <487BB053.90804@goop.org>
In-Reply-To: <487BB053.90804@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> It's also possible I'm missing something from my .config (I'm in the 
> middle of trying to prune it).  It's below (compressed with "grep 
> ^CONFIG").

Duh.  Turned off KMOD.

Sorry for the noise,
    J
