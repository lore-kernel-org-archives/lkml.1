Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYIPO3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYIPO3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYIPO3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:29:06 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:40615 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYIPO3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:29:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lokCilrcG5PIybqXo26FmkTE2F6zCQlxVsKxgFqmU5+pdPxDhG6oFLfcoe9N3GJXCT
         dnJAC1l8pJJiZ/ADHU0WrL/bjNU4e1XnLoUeRcq91zFaDS1E2m1RowpOuZSIsX5rEKXs
         8fzFabz29AvQhHR/iSNfVbNG16cozIyQmRhdE=
Message-ID: <c62985530809160729m261207ben15b6c05440703451@mail.gmail.com>
Date: Tue, 16 Sep 2008 16:29:01 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Xu Yang" <risingsunxy@googlemail.com>
Subject: Re: looking for a function
Cc: "Bernd Petrovitsch" <bernd@firmix.at>, linux-kernel@vger.kernel.org
In-Reply-To: <ab40e9c0809160711p4182d9e7n9b3ce965b3ce9f1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0809160550q411507aeledae30a9f835d09d@mail.gmail.com>
	 <1221573632.6103.83.camel@spike.firmix.at>
	 <ab40e9c0809160711p4182d9e7n9b3ce965b3ce9f1f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/16 Xu Yang <risingsunxy@googlemail.com>:
> Hi Bernd,
>
> thanks for you reply.
>
> yes, I know the thread migrates all the time, this is exactly what I
> would like to observe. I would like to learn about the thread
> migration of some specific scheduling algorithm. so ....
>
> any idea about the function?
>

And perhaps you should have a look at the sched_switch tracer which
will log for you the different context switches.

Regards,

Frederic.
