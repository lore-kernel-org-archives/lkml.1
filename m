Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab0BKVj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:39:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:34762 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757112Ab0BKVjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:39:24 -0500
Date: Thu, 11 Feb 2010 13:38:16 -0800
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 2/2] Staging: hv: General maintenance of TODO file
Message-ID: <20100211213816.GB29557@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56212E881A9@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <8AFC7968D54FB448A30D8F38F259C56212E88291@TK5EX14MBXC118.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56212E88291@TK5EX14MBXC118.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 09:32:31PM +0000, Hank Janssen wrote:
> 
> Removed two line;
> 	Audit block driver
> 	Audit scsi driver
> They were added by us as part of the original code
> Submission to make sure these drivers kept on working
> Correctly with all the patches that came in from the 
> Community. 

Um, no, those things still need to be done.

> Added a new line to fix mostly insane camelcase naming
> We are working on that right now, but it will take a bit
> Due to the pervasive usage of it.

That's fine, but it fits under the general "fix coding style issues".

Hm, that isn't spelled out, but it is implicit, I doubt this really
needs to be documented in the file, it's just common knowledge :)

thanks,

greg k-h
