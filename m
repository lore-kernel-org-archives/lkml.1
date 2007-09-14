Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbXINR2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbXINR2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 13:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbXINR22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 13:28:28 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:10970 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbXINR22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 13:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oLZM++A0h2ItB2kyBS9UW4Oz6dmrVANCYWpZPlJykZb9nrkcxRFBmhsHyjgNyK+OVRnT+ZHeQT5/0s0MeT5LVoulMBqbUSZpIT93HwjwuF5gsNOY6a/EtJ2pR4o2dr0LadHL9ZHPw5w2z3sfEbs400gIw+8kbLw6/aNG6M5evd0=
Message-ID: <86802c440709141028i2b824f76jdee2a278472caeb8@mail.gmail.com>
Date: Fri, 14 Sep 2007 10:28:27 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andreas Herrmann" <aherrman@arcor.de>
Subject: Re: [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org, "dean gaudet" <dean@arctic.org>
In-Reply-To: <20070914112154.GB6727@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070914082129.GA6727@devil> <46E9A391.3000804@zytor.com>
	 <20070914112154.GB6727@devil>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, Andreas Herrmann <aherrman@arcor.de> wrote:
>
> This stuff was long documented in some preliminary NDA specs. And some kernel
> developer(s) had access to it. So if it is such a big deal, why didn't they speak
> up earlier?

I did ask about that when I was porting linuxbios for it. they said
that it is need for ...

YH
