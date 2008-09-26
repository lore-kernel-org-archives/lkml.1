Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbYIZUrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbYIZUrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 16:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYIZUrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 16:47:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:7843 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbYIZUre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 16:47:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uhWV4hgNjDohzyHSuq740dHYuGByovQeDXxDNrKnBKSdwuQiiX67gP4xw6PwzQJZUJ
         /chfU6q601z2gWZK+fZDAbSlaoIDKUbmZoZhYPvX1Mxr//QafbYColyU9BSlwU1HtD0R
         FpkXbekocHTTbecwL4pF1k8n5TCbsSaPaBQwQ=
Message-ID: <f7848160809261347i3d96487do398ac9af3d952712@mail.gmail.com>
Date: Fri, 26 Sep 2008 16:47:33 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Cc: "Greg KH" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Andreas Gruenbacher" <agruen@suse.de>,
       "Jeff Mahoney" <jeffm@suse.de>
In-Reply-To: <48DD4867.4060009@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924230054.GA27730@suse.de> <20080925042108.GA3931@suse.de>
	 <f7848160809250402l163bb177oeed30f2daa18fafd@mail.gmail.com>
	 <20080925205328.GB11225@suse.de>
	 <f7848160809251440jfcd60f9lb962a75ff01798c8@mail.gmail.com>
	 <20080925220454.GA12116@suse.de>
	 <f7848160809251522s4e589b9eu7a4fc9566d2b25e9@mail.gmail.com>
	 <48DD2BA3.7050808@s5r6.in-berlin.de>
	 <f7848160809261311q487493d1pea4e953dd98f881@mail.gmail.com>
	 <48DD4867.4060009@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 4:39 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Parag Warudkar wrote:
>>
>> Just name the staging modules with _stg prefix like I said - easier to
>> spot _stg in the module list than decoding the taint.
>
> ...
>>
>> It is nice to not have to change core kernel code and annoy users with
>> warnings
>
> Yes, let's annoy them with weird name changes instead.

So people now a days crave for documenting staging modules and also
get confused by the mixed use of driver_stg or driver? Come on.

The name changes hardly matter for auto loading staging modules and I
would be surprised if people document crap modules especially since
the stable ones are documented later if at all they end up being
documented.

Parag
