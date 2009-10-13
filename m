Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbZJMOBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbZJMOBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZJMOBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:01:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32816 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751056AbZJMOBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:01:46 -0400
Date: Tue, 13 Oct 2009 15:02:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bo Forslund <bo.forslund@abc.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: answer to "Please submit a full bug report" kernel 2.6.31.4
Message-ID: <20091013150202.5fafb518@lxorguk.ukuu.org.uk>
In-Reply-To: <4AD47201.7000400@abc.se>
References: <4AD47201.7000400@abc.se>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 14:26:41 +0200
Bo Forslund <bo.forslund@abc.se> wrote:

> I got this error messages when trying to build a custom kernel. I don't 
> know if it is the kernel source or the compiler that is failing. It is 

Or the machine.. see if it is repeatable first, if not suspect the
hardware of being flaky. If it is repeatable then it is the compiler

> an out-of-the-box Debian Squeeze system on an old dual cpu bp6 machine.

What compiler version and what architecture ?

> The word "Fel" below translate to Error.

Your compiler broke so you should also report this to the debian gcc
maintainer. However it is useful for the kernel people to know too as it
may be possible to tweak the code to avoid the compiler bug.

Alan
