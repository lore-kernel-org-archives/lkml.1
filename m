Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbYENVe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbYENVe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbYENVec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:34:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46617 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbYENVea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:34:30 -0400
Date: Wed, 14 May 2008 14:33:47 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm <akpm@linux-foundation.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, david.vrabel@csr.com
Subject: Re: uwb build errors: CONFIG_PCI=n, CONFIG_USB=y
Message-ID: <20080514213347.GA23377@kroah.com>
References: <Pine.LNX.4.64.0805061356150.17702@shark.he.net> <20080514131749.17675ba0.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514131749.17675ba0.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 01:17:49PM -0700, Randy Dunlap wrote:
> [dropped closed list: linux-uwb@bughost.org]
> 
> This build error has now moved into 2.6.26-rc2-mm1 also.

I'm trying to get a new set of UWB patches from David that should
hopefully fix this issue.

thanks,

greg k-h
