Return-Path: <linux-kernel-owner+w=401wt.eu-S1761304AbXEUQMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304AbXEUQMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbXEUQMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:12:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:21432 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbXEUQMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:12:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EYZq6/MkinOPyvlXf1/ey1ZJ2+IdZt2HDCynEtw3n26SZzomTXI1dNcYLHkbhlOXQ+nAM3KyofVKuQqNjzufMcewm9qSTJ5jLKKLAQ0N7w+ot2QGKmK6a+EiwfhGEjxhfMafQa0FSDHNsECyjfsWQv5d8R8UGIQdQWTpTXUUVWM=
Message-ID: <3aa654a40705210912l72a0e5bfp6fd1346eec2c023c@mail.gmail.com>
Date: Mon, 21 May 2007 09:12:18 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [Bug 8498], [Bug 8510], and Re: Can't s2ram 22-rc2
Cc: "Andrey Borzenkov" <arvidjaar@mail.ru>,
       "Soeren Sonnenburg" <kernel@nn7.de>, "Greg KH" <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Jiri Slaby" <jirislaby@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "USB development list" <linux-usb-devel@lists.sourceforge.net>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0705211040330.4496-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519164504.GA10675@kroah.com>
	 <Pine.LNX.4.44L0.0705211040330.4496-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> Andrey, Soeren, and Avuton: Please try this patch with 2.6.22-rc2 or
> later and see if it fixes your problems.

It does, I already synced the -rc1 patch that was at the bug link for myself.

Thanks
-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
