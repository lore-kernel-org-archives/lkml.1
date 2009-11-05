Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbZKEHZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbZKEHZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 02:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZKEHZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 02:25:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48196
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115AbZKEHZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 02:25:05 -0500
Date: Wed, 04 Nov 2009 23:25:29 -0800 (PST)
Message-Id: <20091104.232529.96055149.davem@davemloft.net>
To: Valdis.Kletnieks@vt.edu
Cc: gilad@codefidence.com, ilpo.jarvinen@helsinki.fi, eric.dumazet@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, ori@comsleep.com
Subject: Re: 2.6.32-rc5-mmotm1101 - kernel BUG at net/ipv4/tcp_input.c:3707!
From: David Miller <davem@davemloft.net>
In-Reply-To: <6025.1257388392@turing-police.cc.vt.edu>
References: <7916.1257300093@turing-police.cc.vt.edu>
	<4AF1AF28.2030106@codefidence.com>
	<6025.1257388392@turing-police.cc.vt.edu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valdis.Kletnieks@vt.edu
Date: Wed, 04 Nov 2009 21:33:12 -0500

> On Wed, 04 Nov 2009 18:43:20 +0200, Gilad Ben-Yossef said:
> 
>> OK, I thing I've got it.
>> 
>> Kindly try the next patch. It goes on top (in addition to) the previous 
>> one. This should fix the crash.
> 
> OK. much better.  Have been up for about 25 minutes now, and fetchmail has
> pulled down e-mail several times, and no proboems seen.

Thank you for testing.
