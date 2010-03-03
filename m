Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab0CCVYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:24:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab0CCVX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:23:57 -0500
Date: Wed, 3 Mar 2010 13:22:36 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 19/62] Driver-Core: devtmpfs - remove EXPERIMENTAL and
 enable it by default
Message-ID: <20100303212236.GA9732@suse.de>
References: <20100302230933.GA32287@kroah.com>
 <1267572541-410-19-git-send-email-gregkh@suse.de>
 <m1635eow8a.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1003030839550.3627@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003030839550.3627@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 08:46:54AM -0800, Linus Torvalds wrote:
> Greg, please shut down people like Kay that want to enable something by 
> default. We want a _minimal_  working config, not a maximal. If somebody 
> has a distro that needs this, they can enable it _then_. Not "let's try to 
> make people enable it whether they need it or not, because they _might_".

Ok, I'll change this.  Do you want me to redo the whole series, or just
add another patch to revert the 'default y' option here?

thanks,

greg k-h
