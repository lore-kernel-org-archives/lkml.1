Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbYIJNB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbYIJNB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYIJNBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:01:51 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:57584 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYIJNBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:01:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=A+8OLu8p+bpqkoqASfQCNGwqlgNQWbOdRNaJn9t7tWNb1SsjROB2AaAvH7GnUe3R5U
         fe2f7PjsxT6OvcwaTMctAgxEzAZmFxEnb9eNo1qqmw0NEqFsldptS7ec9k2QdAMjvFhM
         6t+SoeI/a+VnuwSa1Ltkuc06/2bY77IF6Ftu8=
Message-ID: <f7848160809100601o56340cf2re9f43cf0c3969d19@mail.gmail.com>
Date: Wed, 10 Sep 2008 09:01:48 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH] x86: sysfs - kill owner field from attribute
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, htejun@gmail.com
In-Reply-To: <20080910053724.GA3632@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f7848160809091611w50270265hc149baeaf267775e@mail.gmail.com>
	 <20080910053724.GA3632@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 1:37 AM, Greg KH <gregkh@suse.de> wrote:

> Why one arch, normally we do it one subsystem at a time :)

Mostly because I at least want to compile test and preferably boot
with the changes - which I can on x86/64.
And somewhat in the hope that some one else will help with changes on
the arches he/she is able to test!

>
> Either way, thanks for doing this, I'll gladly take your fixed up
> version and work to clean up the rest if you don't want to do it.
>

Not that I don't want to do it - just that I can't test it on the
other arches - so please feel free.
The sooner it goes away the better.

Thanks

Parag
