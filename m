Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbYHEPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbYHEPlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759706AbYHEPks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:40:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58523 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbYHEPkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:40:47 -0400
Message-ID: <4898745F.2070902@zytor.com>
Date: Tue, 05 Aug 2008 08:40:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Kyle Moffett <kyle@moffetthome.net>, Russ Anderson <rja@sgi.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: Re: x86 BIOS interface for partitioning and system serial number
 on SGI UV
References: <20080731195753.GB25715@sgi.com> <48934926.2010200@zytor.com>	 <20080804221951.GA252105@sgi.com> <f73f7ab80808042221v5bebcea9o7e536093373647cd@mail.gmail.com> <4898654A.9000904@sgi.com>
In-Reply-To: <4898654A.9000904@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> 
> Hi Kyle,
> 
> As I'm very new to this development arena, could you explain a bit more
> on why this is considered "bad manners"?
> 
> I'm not speaking of any particular change, but there are some realities in
> bringing a new product to market that depends heavily on new "features"
> being accepted into a specific kernel release.  I certainly do not want
> to "taint" any kernel code (and I'm always amazed at the dedication of
> so many individuals to insure this doesn't happen), but the line between
> acceptability (and not) seems to waver all over the place... ;-)
> 

It's because it's your responsibility to get the code in by whenever you 
need it to, but trying to push unfinished code with the motivation "we 
need it in by <release>" violates the development model *and* is just 
plain rude.

This comes down to the old saying "lack of planning on your part does 
not constitute an emergency on my part."

In other words, if you want to push code in by a specific release, the 
code needs to be *done* and properly submitted.  Submitting code that 
has a big "real code goes here" comment, is ridiculous.

Unfortunately we have seen a *lot* of that from several people at SGI 
over the last year.

	-hpa

