Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbYABMeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbYABMeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 07:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYABMeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 07:34:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:28229 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYABMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 07:34:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=My3AP5HvLUOLm33iQ0FXeLA4xn0a064ZizOAhEmpWITUgqL2OSKQrT7qpqDcwhBqJ+9P6UrlNkBqHBMgTQUgdiEBWthLMNOdpMlCbVJeZ4/+0JIseMcv+gP+d2YSm2En35fZemLVTtyrZpgLCSxfXb9ub/V7rYuy/9wX0BPdBgg=
Date: Wed, 2 Jan 2008 13:39:38 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, Dave Young <hidave.darkstar@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Message-ID: <20080102123938.GA3476@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102070008.GA31343@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02-01-2008 08:00, Greg KH wrote:
...
> If no one has noticed any issues in this area, [...]

...Could also mean there are hidden issues, so it doesn't look like
very convincing argument.

...Unless after the change there will be found no hidden issues,
then, of course, it looks like convincing enough.

Regards,
Jarek P.
