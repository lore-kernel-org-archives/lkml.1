Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbXJ1SDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbXJ1SDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbXJ1SC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:02:59 -0400
Received: from smtp801.mail.ird.yahoo.com ([217.146.188.61]:32941 "HELO
	smtp801.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752096AbXJ1SC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:02:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=btinternet.com;
  h=Received:X-YMail-OSG:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding;
  b=PRdL1hH3XY5ZTk8FUMztM1JGtqR6+1C3PJy/tEtQDBbR9m0n0JeDtOrtyJ7EHB2EBM/RxEe2QCEySTK0b+KtScIufGA1qO0xAMb7vlV8ZxOeO3jT2P0FqUVq3I4BhIfTQv6kPs7up+j499xi+pdy3/e+Q5/A4AE3t9H8eROmr1U=  ;
X-YMail-OSG: 1kuDNJcVM1l.5Xedvx2YpIRXJyI5YayZ7tPiRidUBXXmo7HB3QsH4vuCzzSiIhX6ZmwS7Vt9MQ--
Date: Sun, 28 Oct 2007 18:03:16 +0000
From: Bradley Smith <bradjsmith@btinternet.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, dz@debian.org
Subject: Re: [PATCH 1/2] I8K: Allow i8k driver to be built on x86_64 systems
Message-ID: <20071028180316.02536792@debian.hob>
In-Reply-To: <4724CDFA.1080106@garzik.org>
References: <20071028172519.371dbbe8@debian.hob>
	<4724CDFA.1080106@garzik.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 13:59:22 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Bradley Smith wrote:
> > From: Bradley Smith <bradjsmith@btinternet.com>
> > 
> > Adds #if clause and additional inline assembly so that the driver
> > builds on x86_64 systems.
> > 
> > Signed-off-by: Bradley Smith <bradjsmith@btinternet.com>
> 
> Is this actually known to be working on a Dell laptop?
> 
> 	Jeff
> 

Yes, I have a dell laptop, and it works. (I have been using it for quite a while).

Brad.
