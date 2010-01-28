Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101Ab0A1XPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab0A1XPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781Ab0A1XPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:15:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:7600 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab0A1XPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:15:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B8niujvszzxz8XP5YDIohS7vcjSS9X2e57XkPuRXVYgXFcGInwketOm0cXLMW5tWnr
         7SkuiwKNbh8dgx+UFGwUqahwrC1HiZPh0Za+7b0h8UKB8o5jS4U2xqCbmvC2zsHGI4Ix
         uue4Se0+gi2I1OJsIWRlx4N41txrnw341QsmA=
Date: Fri, 29 Jan 2010 00:15:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       Till Kamppeter <till.kamppeter@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, lsb-discuss@lists.linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux wireless GSoC 2010 project ideas
Message-ID: <20100128231545.GH18683@nowhere>
References: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 01:38:27PM -0800, Luis R. Rodriguez wrote:
> Google has confirmed it will have a Google Summer of Code for 2010
> [1]. Last year we had a few projects suggested (4) and accepted (3)
> under the Linux Foundation sponsoring organization umbrella [2].
> Unfortunately out of the three projects that were approved only one
> completed successfully, that of the adding AP support to Network
> Manger. I haven't seen specific updates to the progress of that but I
> do know some patches were indeed submitted to help with this effort.
> Perhaps the student can elaborate more.
> 
> The other projects that did not pass are up as suggestion for this
> year again, but am hoping there are more. If you do have a project
> idea please just go ahead and add your idea to the list of possible
> projects [3]; you don't have to fill out a full page for it for now
> but the more details you can add the better. If the Linux Foundation
> does give us a few slots I recommend we be a little more strict about
> acceptance criteria since our failure rate was pretty high (2/3) and
> it would be better to see other projects get accepted if we do not
> have the confidence our projects will be completed. One possibility to
> help with the success rate of our projects might be to narrow the
> scope down a little more. I think the testing and GeoClue project
> might have been a little too ambitious and although we did have pretty
> excited students we saw no progress at all.
> 
> If you have ideas for projects just feel free to add to the wiki. We
> should strive to get all project ideas finalized by the middle of
> February, latest the end of February. Hopefully towards the end of
> February we can see who would be willing to mentor each project.
> Google plans on starting to accept would-be-mentor organization
> applications on  March 8th so we'll need our ideas finalized well
> before that so we can send them as suggestions to the Linux Foundation
> to see if we can get a few good project candidates accepted.
> 
> [1] http://groups.google.com/group/google-summer-of-code-discuss/browse_thread/thread/d839c0b02ac15b3f
> [2] http://wireless.kernel.org/en/developers/GSoC/2009
> [3] http://wireless.kernel.org/en/developers/GSoC/2010



I'm sorry if I'm a bit off-topic. But as I see this announce,
I'm wondering about the topics for the google summer of code
in the wider scope of the entire kernel.

I'm a student and there are fair chances I'll be free for this
summer so I start to think about applying.

Are there currently some plans concerning other kernel areas?
That doesn't mean I wouldn't be interested in a wireless project :)
but there are many other areas that could host a Gsoc project too
and I don't want to miss the whole variety of proposals.

I guess we also can, as applying students, propose subjects too.
Provided we find a mentor for the given project, which makes the
things harder in this direction I fear.

Anyway, what would be the right place to submit such proposals? I
have various ideas in mind, in topics such as tracing/profiling,
realtime, among other things... (could be: "Do as much bkl bashing
as you can in two months, have fun, be brave...").

Thanks.

