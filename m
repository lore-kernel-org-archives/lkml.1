Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYFVR5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYFVR5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 13:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYFVR5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 13:57:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:49362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbYFVR5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 13:57:42 -0400
Date: Sun, 22 Jun 2008 10:57:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Fix open/close race in saa7134
Message-ID: <20080622105727.251045a3@infradead.org>
In-Reply-To: <20080622172826.GA7487@joi>
References: <20080622100507.779acc59@infradead.org>
	<20080622172826.GA7487@joi>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 19:33:37 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> PS: I can't access 2.6.25 oopses anymore (timeout). Can you fix it?
> http://kerneloops.org/version.php?start=1671168&end=1703935&version=25-release&count=4509

hmmm... seems the database server got a bit overloaded.
I just added a new index that should speed this page up; and it now
works for me again..... (sigh.. I'm a kernel guy not a DBA, the things
one must do to be a kernel guy)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
