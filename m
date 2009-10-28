Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbZJ1Wbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbZJ1Wbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZJ1Wbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:31:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbZJ1Wbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:31:37 -0400
Date: Wed, 28 Oct 2009 15:31:14 -0700
From: Greg KH <gregkh@suse.de>
To: Milan Dadok <milan@dadok.name>
Cc: linux-kernel@vger.kernel.org, "'Hank Janssen'" <hjanssen@microsoft.com>,
       "'Haiyang Zhang'" <haiyangz@microsoft.com>
Subject: Re: [PATCH] 3/3 staging: hv: fix oops in vmbus - missing #include
Message-ID: <20091028223114.GA25962@suse.de>
References: <001601ca581d$5390e0e0$fab2a2a0$@name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001601ca581d$5390e0e0$fab2a2a0$@name>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 11:23:50PM +0100, Milan Dadok wrote:
> Add missing #include to make hv module compile successfull.

What is the platform that causes this patch to be needed?  This doesn't
seem to be needed in my testing here.

thanks,

greg k-h
