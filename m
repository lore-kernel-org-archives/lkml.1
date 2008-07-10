Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbYGJPP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbYGJPP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbYGJPPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:15:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:6292 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbYGJPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bcQAXwlyUFhVS+4CzqBpNTiEXZSULnpGSKnmDC5g5oAN20fDqJ3djzPKs/kp/R2bEH
         idNhoOcG6V+DnbltqhydTsHI6h6m5WbwpfoaTskvVwNWckrQgK+Ass6JUez/Kfj7YC7D
         BTwaFIOtfIIsi7hwhbBT1731zgWkSGIgaMfeE=
Message-ID: <1ba2fa240807100815j6bda3c63q4fc4d0c5da826fe3@mail.gmail.com>
Date: Thu, 10 Jul 2008 18:15:07 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1215700309.3483.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709190915.GA8238@tuxdriver.com>
	 <1215700309.3483.21.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 5:31 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> 1500  Future work
>
> Maybe something about testing? Or I'll do a testing brainstorming
> session after dinner.
>
> Obviously, testing at orbit never worked out, but it'd be good to have
> _something_ other than everybody testing their thing locally. Ties in
> with the virtual hardware, maybe?
>
>From the driver perspective it would be loop back phy (tx/rx), The
peer side might be running on virtual HW. Currently it's not easy to
establish automated regression over the air. Good portion of the flows
can be tested this way.

I'm also looking for easier bug reporting for unexperienced users
maybe some uevent/HAL popping to application and emails it out/. Not
sure really how to handle this and not create spams. I'm just
expecting more real 'end users'.


Thanks
Tomas
