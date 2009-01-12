Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZALPOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZALPOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZALPO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:14:28 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:20177 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZALPO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:14:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DUNJYFy5KRL2vzmx8VKQ/37hCq7OWECkQxIxuUvsqrqIWf3Nua9QvH7GFNY7NBFHPp
         YisCS6awYHsSwd8HgyXOFJ8tT/FKKnSG8GiBiwGpdQvDRsp2BzYt7Yhzu0DL1X803tQI
         aT0cfYjin+HPG51sio6fx+zSRrbDjoCsJ3AWI=
Message-ID: <f058a9c30901120714n55b60bb9h3372983f54d41b6d@mail.gmail.com>
Date: Mon, 12 Jan 2009 15:14:24 +0000
From: "Miguel Figueiredo Mascarenhas Sousa Filipe" 
	<miguel.filipe@gmail.com>
To: "Chris Mason" <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <1231768730.17356.0.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20090111153437.b069d38d.akpm@linux-foundation.org>
	 <1231768730.17356.0.camel@think.oraclecorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 12, 2009 at 1:58 PM, Chris Mason <chris.mason@oracle.com> wrote:
> On Sun, 2009-01-11 at 15:34 -0800, Andrew Morton wrote:
>> http://bugzilla.kernel.org/show_bug.cgi?id=12435
>>

This is by far the biggest issue btrfs has for simple/domestic users.
Its probably the most tested miss-feature of btrfs, something almost
all new testers encounter & report.

Is fixing this having maximum priority?
The sooner this is fixed, less energy is spend by everyone
(entusiasts, testers, bug reporters, bug triagers, mailing list
campers..etc) and we might save some whales, dolphins and pinguins by
reducing our carbon footprint. :)

Kind regards.

>> Congratulations ;)
>
> Rejected documented, that's the best buzilla tag ever ;)
>
> Thanks,
> Chris
>



-- 
Miguel Sousa Filipe
