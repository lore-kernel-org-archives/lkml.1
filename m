Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbYLYOCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbYLYOCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYLYOCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:02:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:20342 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYLYOCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:02:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZV/wFeX/wSR/KO3xIuRoz0nP5FTCPtX2/dbFRRv3rV2c4wMDrOywerVUymVSCKe6nh
         9IQc/nV1D/vLZWG9UupG6GpWpg1nNovWi2pqhS1EO9a1TrCr5BEpY3I5LW1nSvkJrk/8
         MkcekQekOrrT4z6ATLHjkHrOr6N/aaSOcHm6c=
Date: Thu, 25 Dec 2008 17:07:30 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org, Hans Lambrechts <hans.lambrechts@skynet.be>
Subject: Re: Happy v2.6.28
Message-ID: <20081225140730.GA4714@x200.localdomain>
References: <bMLNZ-3QM-1@gated-at.bofh.it> <200812250853.mBP8rxrr004080@server.home.lan> <20081225131402.ldo5rtovjvftgada@m.safari.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225131402.ldo5rtovjvftgada@m.safari.iki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 03:14:02PM +0200, Sami Farin wrote:
> On Thu, Dec 25, 2008 at 09:53:59 +0100, Hans Lambrechts wrote:
> > Dec 25 09:30:45 server kernel: Pid: 5918, comm: sendmail Tainted: G      D   
> > (2.6.28 #60)
> 
> Can you try without proprietary modules?

'G' doesn't mean "proprietary".

And 'D' means "dead" which means this is not the first oops, which means
first one needs to be posted.
