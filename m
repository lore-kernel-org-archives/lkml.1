Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbXJ1Rzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbXJ1Rzp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbXJ1Rzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:55:38 -0400
Received: from smtp810.mail.ird.yahoo.com ([217.146.188.70]:22682 "HELO
	smtp810.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751150AbXJ1Rzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:55:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=btinternet.com;
  h=Received:X-YMail-OSG:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding;
  b=kIunWea1wa9/0aEZYKEHez9LY3t0SvsGXjMP+4IvF0Z5B7j1uim88bhb+XLjQPqCoW7h6oRKiPUhMp4U5DOrHx7h00V8NWd0N5eCL1EVAhRmcp9NSn7x1v7bfRgdJpNrEGhc9Ad6lKJ52G4CTj92Y2zkIYYGsrUDUBseYKtt0m0=  ;
X-YMail-OSG: .puDS7IVM1noXQ7cB9xtsvHNKGBDVL_wY11F0.sr10daJqp0kBHW4vX9O7tH3BvNF9_9x0yQUw--
Date: Sun, 28 Oct 2007 17:55:55 +0000
From: Bradley Smith <bradjsmith@btinternet.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, dz@debian.org
Subject: Re: [PATCH 2/2] I8K: Adds i8k driver to the x86_64 Kconfig
Message-ID: <20071028175555.449e4a9e@debian.hob>
In-Reply-To: <E1ImCDg-0004N6-0s@faramir.fjphome.nl>
References: <20071028172613.236cac1b@debian.hob>
	<E1ImCDg-0004N6-0s@faramir.fjphome.nl>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 18:46:40 +0100
Frans Pop <elendil@planet.nl> wrote:

> Bradley Smith wrote:
> > +config I8K
> > +     tristate "Dell laptop support"
> 
> Shouldn't that be config DELL_I8K, or even DELL_INSPIRON_8K?
> 
> Cheers,
> Frans Pop

I was going by linux-2.6/arch/x86/Kconfig.i386, which has "config I8K" but maybe it should be
changed...

Brad.
