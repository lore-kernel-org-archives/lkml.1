Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbZAFIB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbZAFIB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 03:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbZAFIBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 03:01:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:43621 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbZAFIBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 03:01:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v2O4/e9GOk1JGQIS65njYPmndDtGNgSdcRuSxW05CpRKezsboswWc89YQyZ8CygcqA
         0C4dEEAiN04O4+ZjHo02Jb8IwjRjoSpEn8WAUn2Xzph7vVn6U6QgI1Top2tfEeIZ65cj
         o6hMRKme+aenDpagCQq/cC7i+PupwcU30aDdU=
Date: Tue, 6 Jan 2009 11:01:15 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: david@lang.hm
Cc: Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, yhlu.kernel@gmail.com
Subject: Re: early exception error
Message-ID: <20090106080115.GB7671@localhost>
References: <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm> <20090103161052.GB11093@localhost> <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm> <20090103190316.GB7367@localhost> <20090103212426.GC7367@localhost> <496001A3.1040201@gmail.com> <20090104112919.GC7632@localhost> <alpine.DEB.1.10.0901051420030.27641@asgard.lang.hm> <20090105212511.GA7468@localhost> <alpine.DEB.1.10.0901051519580.27641@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901051519580.27641@asgard.lang.hm>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[david@lang.hm - Mon, Jan 05, 2009 at 03:20:13PM -0800]
> On Tue, 6 Jan 2009, Cyrill Gorcunov wrote:
>
>>
>> Yes, you even may combine it with the patch Johannes proposed.
>> They should not interfere.
>
> I'm not spotting that patch.
>
> David Lang
>

It's here http://lkml.org/lkml/2009/1/5/51

		- Cyrill -
