Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbYBZXgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbYBZXgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYBZXfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:35:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40114 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764006AbYBZXft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:35:49 -0500
Date: Tue, 26 Feb 2008 15:40:25 -0800
From: Greg KH <greg@kroah.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24.1  - kernel does not boot; IRQ trouble?
Message-ID: <20080226234025.GC14117@kroah.com>
References: <20080218050056.fb0fc0bf.akpm@linux-foundation.org> <667844.65249.qm@web52901.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <667844.65249.qm@web52901.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 10:36:00PM +0000, Chris Rankin wrote:
> FYI, this hang still exists in 2.6.24.3 and so I am still needing to boot with the acpi=noirq
> parameter.

You're going to have to refresh my memory.  Was this a problem caused by
the .1 .2 or .3 kernel releases?  Did 2.6.24 have this problem as well,
or was it ok?

thanks,

greg k-h
