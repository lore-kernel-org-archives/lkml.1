Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbYHAWCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbYHAWCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYHAWCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:02:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:40735 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbYHAWCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:02:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=j14lzztKOF+cIlVPzNtJrMqFzh7Wlxoa0r32kSUQGc1/k4Ud1OfSvGsRXnWPfdZDV3
         DVKqotNWiCXCv1Jtm0BbAnlzqIDQ6FbCheYNTR2Q6Wqe3pSB8hl8osfLp5FZtARQm1vx
         Wrwyc2/sgV8MIcrEdtWqW0P/cdcgMX7oWcCSY=
Date: Sat, 2 Aug 2008 03:28:23 +0530
From: Rabin Vincent <rabin@rab.in>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       ming.m.lin@intel.com
Subject: Re: Kernel (2.6.26 final) Oops, problem?
Message-ID: <20080801215823.GA4818@debian>
References: <200807312218.39479.gene.heskett@gmail.com> <200807312359.13737.gene.heskett@gmail.com> <20080801190428.GA2828@debian> <200808011722.28961.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808011722.28961.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 05:22:28PM -0400, Gene Heskett wrote:
> On Friday 01 August 2008, Rabin Vincent wrote:
> 
> [...]
> >f88133d76ea38761b7379d6233b752ed82250a4a in current git appears to be a
> >fix for this.
> >
> >Rabin
> 
> So I assume that it will be in 2.6.27-rc2?
> [...]

It's already in 2.6.27-rc1.

Rabin
