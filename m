Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYHDXbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYHDXbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYHDXai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:30:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40141 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753260AbYHDXai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:30:38 -0400
Date: Tue, 5 Aug 2008 00:13:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Stuart <dstuart@rogers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problems with disk + network on 2.6.25.11-60.fc8
Message-ID: <20080805001330.6d43bcbb@lxorguk.ukuu.org.uk>
In-Reply-To: <48979079.9030409@rogers.com>
References: <48973EB9.90408@rogers.com>
	<20080804184232.601881a8@lxorguk.ukuu.org.uk>
	<4897671F.1050003@rogers.com>
	<20080804214441.0811138e@lxorguk.ukuu.org.uk>
	<48979079.9030409@rogers.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> around the problem (originally I thought it was the on-board 
> controller), so I have my doubts as to whether switching back would help.
> 
> Nonetheless, I will give it a try again and let you know the result.


That would be great - if it makes no difference, yet high network traffic
is the key factor then it mostly eliminates bugs in the network drivers
from suspicion. At that point its time to dig deeper into the chip config.
