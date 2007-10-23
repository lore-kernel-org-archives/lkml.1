Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbXJWNns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbXJWNns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 09:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbXJWNnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 09:43:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:37080 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbXJWNnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 09:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QWYBdfNs9U3jj4s15KoyGm5nvmk2iLZw8MLIghRyLhKw6FpvzudtUcuToWhW33GL8w+uzxkYmC9pD36TXS1cG8jK8GclIg0rW3s1UEWXAqvzUAZGosc4kJY8jRiKVLHv0kKXkfKcdeE1FR7jlDksJ3vqvHbQHI479APd9NipYqo=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Anas Nashif <nashif@linux.intel.com>
Subject: Re: [PATCH] Intel Manageability Engine Interface driver
Date: Tue, 23 Oct 2007 15:42:54 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Marek Dabek <marek.dabek@intel.com>,
       Andrew Morton <akpm@osdl.org>
References: <471CDC5E.4010300@linux.intel.com> <200710230030.03705.maximlevitsky@gmail.com> <471DF8A9.1010605@linux.intel.com>
In-Reply-To: <471DF8A9.1010605@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710231542.54181.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 October 2007 15:35:37 Anas Nashif wrote:
> Hi,
> 
> Maxim Levitsky wrote:
> > 
> > Will integrated sensors on DG965 motherboard be supported?
> > They can be accessed only through the
> > HECI interface, but the board has no AMT, and even if it had one, I don't 
> > think AMT includes HW sensors.
> > 
> True, this is supported using QST.
> 
> > Will it be supported?
> 
> The MEI driver (HECI) is the first step toward supporting this in Linux. 
> We are working on a QST release for Linux in the form of an SDK that can 
> be used for example by lm_sensors to expose the sensors.\
This would be great, any dates?, at least approximate... 

> 
> > I really need it (I have to reboot to bios each time to see the sensors, which is
> > both inaccurate, and annoying)
> > 
> 
> Yes, we know how annoying it is and we are working on it.
> 
> Anas
> 
> > 
> > Best regards,
> > 	Maxim Levitsky
> 
Best regards,
	Maxim Levitsky
