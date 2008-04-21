Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbYDUVvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbYDUVvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYDUVuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:50:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41319
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbYDUVux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:50:53 -0400
Date: Mon, 21 Apr 2008 14:50:55 -0700 (PDT)
Message-Id: <20080421.145055.191487749.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: andrew@ishiboo.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: kernel BUG at /usr/src/linux-2.6.25/kernel/workqueue.c:224!
 (r8169?)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080421212923.GB2931@electric-eye.fr.zoreil.com>
References: <20080421203458.GA2931@electric-eye.fr.zoreil.com>
	<76366b180804211422k33057607p586b5deed7849c07@mail.gmail.com>
	<20080421212923.GB2931@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Mon, 21 Apr 2008 23:29:23 +0200

> Andrew Paprocki <andrew@ishiboo.com> :
> > (It is still marked experimental)
> 
> I'll remove the non-NAPI code. It's long overdue.

Thank you :)
