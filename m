Return-Path: <linux-kernel-owner+w=401wt.eu-S932293AbXB1Vhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbXB1Vhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932314AbXB1Vhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:37:55 -0500
Received: from suite3.10tohost.com ([69.90.40.118]:44954 "EHLO
	suite3.10tohost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293AbXB1Vhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:37:54 -0500
Date: Wed, 28 Feb 2007 11:52:55 -0800
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Zwane Mwaikambo <zwane@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
       Justin Forbes <jmforbes@linuxtx.org>, Andi Kleen <ak@suse.de>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/21] 2.6.19-stable review
Message-ID: <20070228195255.GA7978@kroah.com>
References: <20070221013619.GA30227@kroah.com> <45DC9E1D.40805@redhat.com> <20070221114737.a09be761.akpm@linux-foundation.org> <Pine.LNX.4.64.0702211208500.4043@woody.linux-foundation.org> <m1lkiikcth.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0702272312580.2632@montezuma.windriver.com> <m1ps7uihzo.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ps7uihzo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 05:28:27AM -0700, Eric W. Biederman wrote:
> 
> What are the rules that are supposed to govern backports to stable
> trees these days anyway?

Documentation/stable_kernel_rules.txt

thanks,

greg k-h
