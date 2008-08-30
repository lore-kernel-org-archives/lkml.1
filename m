Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbYH3TWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbYH3TWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYH3TWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:22:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:57257 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYH3TWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:22:40 -0400
Date: Sat, 30 Aug 2008 12:22:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaswinder Singh <jaswinder@infradead.org>, xorg@lists.freedesktop.org
Subject: Re: Linux-2.6.27-rc5, drm errors in log
Message-ID: <20080830122242.32d73b32@infradead.org>
In-Reply-To: <200808301452.04634.gene.heskett@verizon.net>
References: <200808301452.04634.gene.heskett@verizon.net>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2008 14:52:04 -0400
Gene Heskett <gene.heskett@verizon.net> wrote:

> Greetings all;
> 
> A re-repeat of a previous posting which has not drawn a comment. With
> added content, added CC to a patch author, and some new questions.
> 
> Machine is an F8 install, Athlon xp-2800 on an nforce2 motherboard,
> running an older radeon 9200SE (RV280 based) video card.  No problems
> if I reboot to 2.6.27-rc4.


since half this sort of driver is in userspace it helps if you also add
the version of the userspace driver you are using (and if you changed
it recently)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
