Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbZJZSxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbZJZSxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZJZSxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:53:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:43476 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761AbZJZSxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:53:51 -0400
Date: Mon, 26 Oct 2009 11:48:18 -0700
From: Greg KH <gregkh@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-ID: <20091026184818.GB21591@suse.de>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com>
 <20091023161006.GA1580@ucw.cz>
 <20091026165518.GE2792@tuxdriver.com>
 <20091026172434.GI25725@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026172434.GI25725@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 06:24:34PM +0100, Pavel Machek wrote:
> Anyway, for moving to staging, TODO file describing what needs to be
> fixed before it is brought back was listed as a requirement. So it
> looks like staging is wrong tool for the job.

I will add such a TODO file.

It will say:
	- A maintainer is needed to take ownership of this driver and
	  they must be willing to maintain and test any future api
	  changes needed.

thanks,

greg k-h
