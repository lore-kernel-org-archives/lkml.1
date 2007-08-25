Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbXHYVSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbXHYVSi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 17:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbXHYVS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 17:18:28 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:20632 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbXHYVS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 17:18:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=jSacpmXQI63vcunmUOhOKL03hJeKvjaKBi3XqClMV0MQlD3yKwKvY5peL3w3hG+6xceDg5YPk1JU51Xb14mR0o9zECR1NWYy2WrBZZWaszetfi8xK8REa1pfGWC4/1A6/O5nvJJfDc51iaTz8pxSJNxhBtNJFcjis2Amhdk20UI=
Date: Sat, 25 Aug 2007 23:14:06 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, kraxel@redhat.com
Subject: Re: [-mm patch] enforce noreplace-smp in alternative_instructions()
Message-ID: <20070825211405.GA18217@slug>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070822202551.GB31846@slug> <20070823145038.9895784f.akpm@linux-foundation.org> <20070824060438.GE31846@slug> <46CE7EDC.9080007@goop.org> <20070824082249.GG31846@slug> <1188043649.20041.81.camel@localhost.localdomain> <20070825122324.GA6138@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070825122324.GA6138@slug>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2007 at 02:23:24PM +0200, Frederik Deweerdt wrote:
> On Sat, Aug 25, 2007 at 10:07:29PM +1000, Rusty Russell wrote:
> > Do you need noreplace-smp even on 2.6.23-rc3,
> > or only 2.6.23-rc3-mm1?
> I'll try ASAP.
> 
Ok, tested: I need noreplace-smp + patch to make it work on mainline too.

Regards,
Frederik
