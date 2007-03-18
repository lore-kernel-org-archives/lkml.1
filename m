Return-Path: <linux-kernel-owner+w=401wt.eu-S1750740AbXCRXPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750740AbXCRXPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 19:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXCRXPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 19:15:10 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:12264 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbXCRXPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 19:15:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=SfbwAKfV3u4nuKHio1uuwJYFfXsn8vYHUNGBS9tOuKa1lsQkOpEU5WHPrXdk7JBKVQbYxz8lhB4wOswhiwgpg5Euwh3UYJIbqGSvGAKHQ5iYMjuk92RU+4f36oJKoR9WJyOb+HSfUOXTTMDjSO0JeY8UgzAMCEj7icbGx0jVj+I=
Date: Mon, 19 Mar 2007 01:15:00 +0200
To: linux-kernel@vger.kernel.org
Subject: Re: i386: Why putting __USER_DS in kernel threads stack initialization?
Message-ID: <20070318231500.GC3802@Ahmed>
References: <20070318225831.GB3802@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318225831.GB3802@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 12:58:31AM +0200, ahmed wrote:
> 
> P.S. I've tried commenting out both lines which led to a non functional init,
> Also setting them to __USER_DS made init start but stopped issuing the error:
> `Panic: Segment violation at 0x8049798 - Sleeping for 30 seconds'
> 

Sorry, I meant setting them to __KERNEL_DS.

Thanks,

-- 
Ahmed S. Darwish
http://darwish.07.googlepages.com

