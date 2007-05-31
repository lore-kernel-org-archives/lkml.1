Return-Path: <linux-kernel-owner+w=401wt.eu-S1760761AbXEaQvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761AbXEaQvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbXEaQvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:51:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:25452 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbXEaQvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:51:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=t3gAxc9lSt7nuYMS/qqRkCva5Rj6EYNfPS8NRVtNOVJPbvtRG0V1gQil1uCfP5Q+f
	ekSoN5daSDUclAilmqwmQ==
Message-ID: <b040c32a0705310951t7d9acdf5n34815bc5fc156e26@mail.gmail.com>
Date: Thu, 31 May 2007 09:51:36 -0700
From: "Ken Chen" <kenchen@google.com>
To: walt <wa1ter@myrealbox.com>, "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: + loop-preallocate-eight-loop-devices.patch added to -mm tree
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f3mro0$u8p$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705212200.l4LM0tYK021050@shell0.pdx.osdl.net>
	 <20070522001851.GE4095@ftp.linux.org.uk>
	 <b040c32a0705211830h127dfd8dk8930de6655d37d90@mail.gmail.com>
	 <20070522014822.GF4095@ftp.linux.org.uk>
	 <b040c32a0705211914w3843bd46o542476be97e0b6cf@mail.gmail.com>
	 <b040c32a0705211940xe7cdf1cnb2c882edacc17a27@mail.gmail.com>
	 <f3mro0$u8p$1@sea.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/07, walt <wa1ter@myrealbox.com> wrote:
> Ken Chen wrote:
> > On 5/21/07, Ken Chen <kenchen@google.com> wrote:
> ...
> > tested, like this?
>
> Ken, your patch below works for me.  Are you going to send this
> on to Linus?

I think akpm will route this to Linus.  andrew?
