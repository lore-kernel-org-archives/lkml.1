Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbXFXUUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbXFXUUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbXFXUT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:19:57 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:50812 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbXFXUTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:19:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ABl8W1qwKS+Zet8dRKAnVB24TO2hNCd4n9/oAdu9XS0z89jiD1PS3wGgwMXVl35jkWvbojpYQ28BAkhYfe2jfJ2l4F8W3skTLjt2Ll1bumKTpV2PyfVE3tlAuMR6ryZTJn+lRDBBQQssJcITkvW6gRDZhDu7Uv60P8vKjvve/Fg=
Message-ID: <7e63f56c0706241319i4c4c62e8keaaf8848d0b7e5c2@mail.gmail.com>
Date: Sun, 24 Jun 2007 22:19:55 +0200
From: "Robert Iakobashvili" <coroberti@gmail.com>
To: djones@rossove.com
Subject: Re: Scaling Max IP address limitation
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070624110236.fa36b2f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467EA7C1.4080006@rossove.com>
	 <20070624110236.fa36b2f9.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 24 Jun 2007 12:20:01 -0500 David Jones <djones@rossove.com> wrote:
> > I am trying to add multiple IP addresses ( v6 ) to my FC7 box on eth0.
> > But I am hitting a max limit of 4000 IP address . Seems like there is a
> > limiting variable in linux kernel (which one? ) that prevents from
> > adding more IP addresses than 4096. What do I need to change in Linux
> > kernel  ( and then recompile ) to be able to add more IP addresses than
> > 4K addresses per system? ..

How are you doing this?

Could it be some IPv6 issue like scope?


-- 
Sincerely,
Robert Iakobashvili,
coroberti %x40 gmail %x2e com
...........................................................
http://curl-loader.sourceforge.net
A web testing and traffic generation tool.
