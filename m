Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYJWATh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYJWATh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 20:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYJWAT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 20:19:29 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:46835 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbYJWAT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 20:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=G9gSNdTjb5Tijw0/AilvGdjm6z87Kt1csCZMKvpQ0X/H30MMVZq68fFf27wxknZO0B
         ADVrA8j/FfYZwn/eNT0vFN26jYaGzPm+SptRgw5LU1+ZONHaH8Os2MdkZooBhzQ3VKjp
         3jrRypXyb5Psvl4WrcLIccYAHueCXe1rUc4nU=
Date: Wed, 22 Oct 2008 20:19:15 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Hollis Blanchard <hollis@penguinppc.org>,
       Paul Mackerras <paulus@samba.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: build failure on powerpc with current -git
Message-ID: <20081023001915.GA30920@zod.rchland.ibm.com>
References: <48F8E86B.702@nortel.com> <18685.27030.529655.761257@cargo.ozlabs.ibm.com> <20081021191324.d4810d40.sfr@canb.auug.org.au> <18686.42209.47915.184451@cargo.ozlabs.ibm.com> <fb412d760810220819o1a15d47ej198f6e15c3e63f15@mail.gmail.com> <48FF67E1.4070001@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FF67E1.4070001@nortel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 11:50:25AM -0600, Chris Friesen wrote:
> Hollis Blanchard wrote:
>
>> binutils 2.16.1 is the most recent binutils that will build with  
>> crosstool, so IMHO it's worth supporting. :)
>
> I was wondering about that....wasted a bunch of time trying to build 
> something more recent.

I built binutils 2.18 for ppc, ppc no-float, ppc64, mips, and i386
yesterday.  It worked fine...

josh
