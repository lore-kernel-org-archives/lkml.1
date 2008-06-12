Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbYFLLiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbYFLLiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 07:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYFLLh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 07:37:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:54192 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbYFLLh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 07:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xcwwsTbmEoLHZE1f0PZH+ic8mygw4N+4tmUNdQb2jvkO/ub/Yp6MlXOQTGYKmytpGQ
         LkAaJ9iLyrjO9/8oaEAuJCdCh2mmh4Luxke6yf2gPHyGL2ACBPIPCinzG5dt2M2KYk2d
         ZgSOV4GRgIsUh0BREY+5qh5T4y73cTQpjZbiE=
Message-ID: <87a5b0800806120437n23602ba5raae500f5bd3d179f@mail.gmail.com>
Date: Thu, 12 Jun 2008 12:37:56 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [ANNOUNCE] linux-staging tree created
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors@vger.kernel.org, linux-next@vger.kernel.org,
       "Stephen Rothwell" <sfr@canb.auug.org.au>
In-Reply-To: <20080611162639.GE22134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080610190540.GA25066@kroah.com>
	 <87a5b0800806110345v77529fc8r591f2fb4c95b5bdf@mail.gmail.com>
	 <20080611162639.GE22134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 5:26 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Jun 11, 2008 at 11:45:55AM +0100, Will Newton wrote:
>>
>> Would the linux-staging tree be an appropriate place to merge a new
>> architecture? Or would that be too large a change and should go via
>> its own tree?
>
> That is probably too big to go into -staging and should deserve its own
> tree based on the size of patches that have gone into creating a new
> architecture in the past.

Our tree is about 26000 lines of diff, including a few drivers.

> Do you have an example of one that is currently not included in the main
> kernel tree right now?

I have a tree that is currently about half way to public consumption,
although I don't think there's any point pushing it until we have a
publically available toolchain.

> thanks,
>
> greg k-h
>
