Return-Path: <linux-kernel-owner+w=401wt.eu-S1760269AbYFZMuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbYFZMuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbYFZMdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:33:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:2504 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758433AbYFZMdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SHgcST4W/cXsXoFwj7Ct9bihn3n06YpZlXtBMRFWqkO5ZEVz1qg8ITwXIHiPrRT7Fz
         Qlsmb8wq5+7dALS4RjZwl5CNIwUuCGnzS1rkOnBtAxYfdaEkmu1RjqUa5/gF5MyuKPPT
         W71C4khkyCagxt60+yDr0I6DV6LjFmSeO6DIg=
Message-ID: <6101e8c40806260533v58d87gbb0866430dbf8746@mail.gmail.com>
Date: Thu, 26 Jun 2008 14:33:50 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: What's in linux-2.6-block.git for 2.6.27
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080626122648.GU20851@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080626115404.GS20851@kernel.dk>
	 <6101e8c40806260522u44eff375l8cd02b0f0931e9a8@mail.gmail.com>
	 <20080626122648.GU20851@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks for the fast response

On 6/26/08, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, Jun 26 2008, Oliver Pinter wrote:
>> Hi Jens!
>>
>> this:  - Write starvation fix for 'AS', a very long standing bug for
>> 2.6.26 is to big change?
>
> Probably not, but since this bug has existed for years with very little
> impact, it's not critical enough to warrant direct inclusion. Thus, it's
> queued up with the rest of the changes for the next release.
>
> --
> Jens Axboe
>
>


-- 
Thanks,
Oliver
