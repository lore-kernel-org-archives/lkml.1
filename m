Return-Path: <linux-kernel-owner+w=401wt.eu-S936334AbYEURbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936334AbYEURbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932894AbYEURbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:31:44 -0400
Received: from sous-sol.org ([216.99.217.87]:52648 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809AbYEURbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:31:43 -0400
Date: Wed, 21 May 2008 10:31:27 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Tarkan Erimer <tarkan@netone.net.tr>
Cc: Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Suggestion About Kernel Releases
Message-ID: <20080521173109.GD4018@sequoia.sous-sol.org>
References: <48341ED5.7060508@netone.net.tr> <20080521063855.0bdb441c@infradead.org> <48342ADC.3030509@netone.net.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48342ADC.3030509@netone.net.tr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tarkan Erimer (tarkan@netone.net.tr) wrote:
> To make kernel releases more stable/tested via "testX" series, as recently 
> discussed by David Miller's "Slow DOWN, please!!!" thread.

Arjan already pointed out that this was about the merge window, not the
tail.

> These "testX" 
> releases will give more opportunity and time to test more these new 
> releases. Also, with the aim of the "testX" series, the new kernel release 
> schedules/merge windows will be not slow down. Even, Linus can releases new 
> kernels more quickly. Because, testing purpose should be handled by someone 
> else like Chris did for 2.6.x.y.

(BTW, Greg does 2.6.x.y as well).  What you are missing is that it is not
Greg and I who are doing the bulk of testing for 2.6.x.y.  It's the entire
community, and adding additional stage to the tail or the release cycle
will not increase testing coverage.  History shows it'll just postpone it.

thanks,
-chris
