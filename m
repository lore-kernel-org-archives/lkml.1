Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbXHPGof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbXHPGof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 02:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXHPGo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 02:44:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:52268 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752443AbXHPGo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 02:44:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+jJg4Px1Sj4vc0fgheJablswn5kQGS23GSiEvZed
	o7OiZ59dqv7u+f
Subject: Re: QUESTION: RT & SCHED & fork: ?MISSING EQUIV of
	task_new_fairfor RT tasks.
From: Mike Galbraith <efault@gmx.de>
To: Mitchell Erblich <erblichs@earthlink.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dmitry.adamushko@gmail.com
In-Reply-To: <000501c7df67$a644c9e0$6501a8c0@earthlink.net>
References: <000501c7df67$a644c9e0$6501a8c0@earthlink.net>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 08:44:22 +0200
Message-Id: <1187246662.6824.25.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-15 at 11:10 -0700, Mitchell Erblich wrote:

> However,
>     in reality,  alot of RT class specific init is done. Just currently 
>     none of it is done in this non-existant function.

Patch?

