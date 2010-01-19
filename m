Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772Ab0ASJFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab0ASJFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727Ab0ASJFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:05:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38060
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755358Ab0ASJE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:04:59 -0500
Date: Tue, 19 Jan 2010 01:05:07 -0800 (PST)
Message-Id: <20100119.010507.162666574.davem@davemloft.net>
To: sshtylyov@ru.mvista.com
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/64] ide: fix for ide_timing quantisation errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B54B1CE.7030901@ru.mvista.com>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118171720.14623.86072.sendpatchset@localhost>
	<4B54B1CE.7030901@ru.mvista.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date: Mon, 18 Jan 2010 22:09:02 +0300

>   Comment style should preferrably be:
> 
> /*
> * blah
> * blah
> * blah
> */

Agreed.
