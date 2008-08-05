Return-Path: <linux-kernel-owner+w=401wt.eu-S1762067AbYHEP4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067AbYHEP4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761456AbYHEP41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:56:27 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43578 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761372AbYHEP40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:56:26 -0400
Message-ID: <48987829.1060002@sgi.com>
Date: Tue, 05 Aug 2008 08:56:25 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Kyle Moffett <kyle@moffetthome.net>, Russ Anderson <rja@sgi.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: Re: x86 BIOS interface for partitioning and system serial number
 on SGI UV
References: <20080731195753.GB25715@sgi.com> <48934926.2010200@zytor.com>	 <20080804221951.GA252105@sgi.com> <f73f7ab80808042221v5bebcea9o7e536093373647cd@mail.gmail.com> <4898654A.9000904@sgi.com> <4898745F.2070902@zytor.com>
In-Reply-To: <4898745F.2070902@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Mike Travis wrote:
>>
>> Hi Kyle,
>>
>> As I'm very new to this development arena, could you explain a bit more
>> on why this is considered "bad manners"?
>>
>> I'm not speaking of any particular change, but there are some
>> realities in
>> bringing a new product to market that depends heavily on new "features"
>> being accepted into a specific kernel release.  I certainly do not want
>> to "taint" any kernel code (and I'm always amazed at the dedication of
>> so many individuals to insure this doesn't happen), but the line between
>> acceptability (and not) seems to waver all over the place... ;-)
>>
> 
> It's because it's your responsibility to get the code in by whenever you
> need it to, but trying to push unfinished code with the motivation "we
> need it in by <release>" violates the development model *and* is just
> plain rude.
> 
> This comes down to the old saying "lack of planning on your part does
> not constitute an emergency on my part."
> 
> In other words, if you want to push code in by a specific release, the
> code needs to be *done* and properly submitted.  Submitting code that
> has a big "real code goes here" comment, is ridiculous.
> 
> Unfortunately we have seen a *lot* of that from several people at SGI
> over the last year.
> 
>     -hpa

Hi Peter,

Ok, thanks, I do see your point (very clearly), as I prepare yet another
"we really, really need this" patch... ;-)

[ok, it's only a led driver and the world won't stop if it doesn't show up
in the kernel... ;-)]

Cheers,
Mike
