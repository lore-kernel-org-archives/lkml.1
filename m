Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbZJZSxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbZJZSxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZJZSxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:53:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:43470 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468AbZJZSxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:53:48 -0400
Date: Mon, 26 Oct 2009 11:47:34 -0700
From: Greg KH <gregkh@suse.de>
To: david@lang.hm
Cc: "John W. Linville" <linville@tuxdriver.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-ID: <20091026184734.GA21591@suse.de>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com>
 <20091023161006.GA1580@ucw.cz>
 <20091026165518.GE2792@tuxdriver.com>
 <alpine.DEB.2.00.0910261013430.11504@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910261013430.11504@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 10:18:20AM -0700, david@lang.hm wrote:
> if someone were to claim 'maintainership' and then do nothing other than 
> complain if someone else were to change an API but not fix this in the 
> process, how would this be different than the current situation?

A person "claiming maintainership" would then be responsible for keeping
the API up to date and ensuring that the driver worked.  To do that,
hardware would probably need to be present.

Do you have this kind of hardware and are willing to accept ownership of
this driver?

thanks,

greg k-h
