Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbXGRMfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbXGRMfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 08:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbXGRMfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 08:35:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:2267 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbXGRMe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 08:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uotl4cJlf7Iuri0LRSOYr5cxSLP15Gm3kn5pR1YtSRzRtN4ktlN8u9pmG4vPVU0ee1czs71x9XkfS7J/5Ukag2I13bFUBPyHxKjphCWYeQmvkunjn/NT0saVeLmUmWTycWUfZgHdtnFXWpRD1+p9H1yfJeTexSw7KHtGJSp/afg=
Message-ID: <469E08ED.3020307@gmail.com>
Date: Wed, 18 Jul 2007 21:34:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] block: factor out bio_check_eod()
References: <20070530093503.GA15559@kernel.dk> <20070718105655.GB22374@htj.dyndns.org> <20070718105946.GC22374@htj.dyndns.org> <20070718110619.GM11657@kernel.dk> <469DF700.4030806@gmail.com> <20070718113103.GO11657@kernel.dk> <469DFA75.6070205@gmail.com> <20070718113450.GP11657@kernel.dk> <469DFC61.2070301@gmail.com> <20070718114558.GR11657@kernel.dk> <20070718114955.GS11657@kernel.dk>
In-Reply-To: <20070718114955.GS11657@kernel.dk>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> somewhat annoying, I'll see if I can prefix it with git-daemon in the
>> future.
> 
> OK, now skip the /data/git/ stuff and just use
> 
> git://git.kernel.dk/linux-2.6-block.git

Alright, it works like a charm now.  Thanks.

-- 
tejun
