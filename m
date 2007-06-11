Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbXFKHq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbXFKHq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 03:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbXFKHqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 03:46:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:37408 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbXFKHqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 03:46:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=DuYiojMG6yu1QDtk3P/iDyc6x7tgoMX7Pb/5l5l/LR6gpm40ItH/T+0/EeVnyC938/xxCRXfKf4P5h1vHlpqTTvxyTn6TQsbgi7YyrZv6Pfo2AQ7YJd9oA5lvFCf5SMbsEpM7DK6oiqcMu4vAzG5JTvghWORCKvaX/MtVeF0QO4=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: kconfig .po files in kernel tree? [Was: Documentation/HOWTO translated into Japanese]
Date: Mon, 11 Jun 2007 09:46:11 +0200
User-Agent: KMail/1.8.2
Cc: Rene Herman <rene.herman@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Greg KH <gregkh@suse.de>, Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <200706110159.00482.vda.linux@googlemail.com> <20070611005613.GA20984@linux-sh.org>
In-Reply-To: <20070611005613.GA20984@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706110946.11808.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2007 02:56, Paul Mundt wrote:
> On Mon, Jun 11, 2007 at 01:59:00AM +0200, Denis Vlasenko wrote:
> > On Sunday 10 June 2007 20:58, Rene Herman wrote:
> > > All that stuff only serves to multiply the speed at which a fixed
> > > percentage of content obsoletes itself. When it's still new and
> > > shiny, sure, stuff will get translated but in no time at all it'll
> > > become a fragmented mess which nobody ever feels right about removing
> > > because that would be anti-social to all those poor non-english
> > > speaking kernel hackers out there.
> > 
> > I agree. i18n efforts won't help one iota because people just have
> > to know English in order to participate in l-k development.
> 
> That's a ridiculous statement. Non-native language abilities and
> technical competence have very little to do with each other. People have
> to understand the code and figure out what it is that they want to
> change. As long as this is done cleanly and the intent is obvious,
> language doesn't even factor in beyond the Signed-off-by tag. Explanation
> is necessary from time to time, but it really depends on the area in
> which someone is working. If it's a complicated and involved change, then
> of course it takes a bit more effort on both sides, but that doesn't
> invalidate the importance or necessity of the work.

Point me to one person who doesn't know English at all
and who has successfully participated in l-k devel.

I'm not saying that non-English should banned or something.
In Kconfig it can even make sense. A section on kernel.org
where people can put translations is also a good idea.
I can still think that it is almost useless activity,
but who knows, maybe I'm wrong.

Just not Documentation/<lang>/* thing and no i18n of printks.
--
vda
