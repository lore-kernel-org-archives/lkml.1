Return-Path: <linux-kernel-owner+w=401wt.eu-S1764359AbYASBak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764359AbYASBak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760171AbYASBac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:30:32 -0500
Received: from ozlabs.org ([203.10.76.45]:48969 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760074AbYASBac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:30:32 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/3] Improve type handling in interrupt handlers
Date: Sat, 19 Jan 2008 12:29:58 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ash Willis <ashwillis@programmer.net>, linux-pcmcia@lists.infradead.org
References: <200801190722.26154.rusty@rustcorp.com.au> <47910F05.8040501@pobox.com>
In-Reply-To: <47910F05.8040501@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801191229.59179.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2008 07:41:41 Jeff Garzik wrote:
> FWIW, I have been working in this area extensively.

Excellent...

> Check out the 'irq-cleanups' and 'irq-remove' branches of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

Your irq-cleanups branch is nice work!  But AFAICT these patches are not 
included in your irq-cleanups branch.  Did you want me to switch my patch 
over to irqreturn_t and send them for you to roll in?

Cheers,
Rusty.
