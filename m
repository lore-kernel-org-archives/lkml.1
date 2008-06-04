Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbYFDDQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbYFDDQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 23:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYFDDQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 23:16:23 -0400
Received: from [198.99.130.12] ([198.99.130.12]:33365 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYFDDQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 23:16:23 -0400
Date: Tue, 3 Jun 2008 23:15:21 -0400
From: Jeff Dike <jdike@addtoit.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nix <nix@esperi.org.uk>,
       dhazelton@enter.net, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
Message-ID: <20080604031521.GA15327@c2.user-mode-linux.org>
References: <20080603190235.GA9511@c2.user-mode-linux.org> <20080603123211.e129c222.akpm@linux-foundation.org> <200806031543.56864.dhazelton@enter.net> <878wxmfg99.fsf@hades.wkstn.nix> <20080603130709.fcf6a751.akpm@linux-foundation.org> <20080603210048.GA12182@c2.user-mode-linux.org> <m1zlq2vuh2.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zlq2vuh2.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 06:50:49PM -0700, Eric W. Biederman wrote:
> Could using a CLOCK_MONOTONIC time source fix this?  Those timers do not
> change when we change the time on the host.

Hmmm, maybe.  The man page looks promising...

      	      	      Jeff

-- 
Work email - jdike at linux dot intel dot com
