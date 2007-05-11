Return-Path: <linux-kernel-owner+w=401wt.eu-S933826AbXEKUxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826AbXEKUxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbXEKUx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:53:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:43564 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760572AbXEKUxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=c4DUcJ0RF9p8GopyB2zZ6zVBXUe8vtHX3RecucJdRfu0HtEzzNibvsyMYOywI906nmiXKwLfbIGupVfvmpAqwU3Ktsqdx6Q2vm8Jaq3WXYR6LUJ1AIR8MVoMFZ3O5iUnTbse9Wh1beCtJuNk6qEEBkS365lEAsXEPk2VaVchLTc=
Message-ID: <4644D72C.9000401@gmail.com>
Date: Fri, 11 May 2007 22:50:52 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rusty Russell <rusty@rustcorp.com.au>,
       bunk@stusta.de, randy.dunlap@oracle.com, akpm@linux-foundation.org,
       rpjday@mindspring.com, marcel@holtmann.org, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module_author: don't advice putting in an email address
References: <4643BDF2.9030105@gmail.com> <20070511114605.4c2698ec@the-village.bc.nu> <alpine.DEB.0.98.0705110740420.12363@sigma.j-a-k-j.com>
In-Reply-To: <alpine.DEB.0.98.0705110740420.12363@sigma.j-a-k-j.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2007 01:42 PM, John Anthony Kazos Jr. wrote:

> Can't we just subtitle it somehow? Add tags: " (current maintainer)", "
> (original author, inactive)", " (bug and defect reports)", or whatever 
> you like after the names.

Yes, that's close to Rusty's version of the original MODULE_MAINTAINER proposal:

http://lkml.org/lkml/2007/4/23/115

If I have the "ignore those other addresses you see listed here please, this 
is the contact address" method this would provide, I don't believe more 
annotations would be needed really.

Rene.

