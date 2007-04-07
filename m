Return-Path: <linux-kernel-owner+w=401wt.eu-S933251AbXDGQFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbXDGQFG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 12:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932881AbXDGQFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 12:05:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:53744 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251AbXDGQFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 12:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jbqkpyk/fpjyykmHtwOR7mfKFV7bpATlCQmZYfrEwrOYzkNn1bDIgkhzDLlI8iPHrKe2lmCtz/JB+DRAOpGhPPbI0+41M3WECXBlfMVEMVp5Z/WrixarorvaFqyTEIcQnZk9mTZIK9WOjpl3P6ZS8HiCR5wgzJ9W31bL2WQM6NQ=
Message-ID: <84144f020704070905q587bdadah9f670727516dea43@mail.gmail.com>
Date: Sat, 7 Apr 2007 19:05:02 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "johnrobertbanks@fastmail.fm" <johnrobertbanks@fastmail.fm>
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>, "Jan Harkes" <jaharkes@cs.cmu.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1175958475.27071.1183468234@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46157B5B.5000602@gmail.com>
	 <1175823288.25662.1183293506@webmail.messagingengine.com>
	 <4615C780.5040407@zytor.com>
	 <1175833931.8916.1183307802@webmail.messagingengine.com>
	 <20070406152119.GC4228@delft.aura.cs.cmu.edu>
	 <1175914056.9653.1183426876@webmail.messagingengine.com>
	 <20070407033049.GI4228@delft.aura.cs.cmu.edu>
	 <1175925525.21154.1183436614@webmail.messagingengine.com>
	 <m34pns46l9.fsf@maximus.localdomain>
	 <1175958475.27071.1183468234@webmail.messagingengine.com>
X-Google-Sender-Auth: a49249472befb2b4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/7/07, johnrobertbanks@fastmail.fm <johnrobertbanks@fastmail.fm> wrote:
> I checked what bonnie++ actually writes to its test files, for you. It
> is about 98-99% zeros.
>
> Still, the results record sequential reads, of 232,729 K/sec, nearly
> four times the physical disk read rate, 63,160 K/sec, of the hard drive.

Excellent! You've established the undeniable hard cold fact that
reiser4 beats the crap out of all other filesystems, when the files
are 98-99% filled with zeros. You've proven your point, so can we stop
this thread now?
