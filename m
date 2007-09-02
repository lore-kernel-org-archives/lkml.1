Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbXIBTkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbXIBTkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXIBTke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:40:34 -0400
Received: from mail.macqel.be ([194.78.208.39]:21536 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbXIBTkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:40:33 -0400
Date: Sun, 2 Sep 2007 21:40:31 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org
Subject: Hint needed : how to debug sempahore's problem
Message-ID: <20070902194031.GA24800@ingate.macqel.be>
References: <20070713102610.GA16087@muff.macqel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713102610.GA16087@muff.macqel.be>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Can someone give me some hint or link for the following question :

I have several processes blocked in 'D' state, and I surmise they are
waiting for a semaphore (in the `down' routine).  How is it possible :
- to verify the processes are really blocked on a semaphore,
- to see which semaphore they are waiting on,
- to find out which process/driver/whatever holds those semaphores.

If that matters, I work on a m68k board.

Thanks in advance

Philippe
