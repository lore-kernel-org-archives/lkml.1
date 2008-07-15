Return-Path: <linux-kernel-owner+w=401wt.eu-S1761209AbYGOQnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209AbYGOQnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYGOQnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:43:13 -0400
Received: from mux2.uit.no ([129.242.5.252]:49448 "EHLO mux2.uit.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbYGOQnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:43:12 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2008 12:43:12 EDT
X-DKIM: Sendmail DKIM Filter v2.6.0 mux2.uit.no m6FGaqEo067622
Date: Tue, 15 Jul 2008 18:36:52 +0200
From: Tobias Brox <tobias@stud.cs.uit.no>
To: linux-kernel@vger.kernel.org
Subject: Re: From 2.4 to 2.6 to 2.7?
Message-ID: <20080715163652.GA12728@lgserv3.stud.cs.uit.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080715142444.GA7121@asus>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov]
> Some areas should be distinguished:

Areas?  "Target audience groups" maybe?  Well, I'm also not a native
English writer ;-)

>	- development/stable team
>	- distros
> 	- regular users

> So we have the quite large group of people which should be considered for
> convenient versioning scheme - _regular users_. Lets say I'm a regular user -
> the most convenient scheme for me would be YYYY.r.s i think since it tells
> me - this kernel is fresh enough to be used on my shining laptop, and maybe
> it even supports all hardware I have! And at least it looks good -
> 	Linux-2008.0.0

So, the version numbers aren't important for anyone else than "regular
users"?  Ok, I'm a "regular user", so then I'm qualified to comment
;-)

Microsoft has attempted using year numbers in their releases, do we
really want to go the same way? ;-) Well, indeed - my vote goes in the
direction of YYYY.r.s.  I have one concern though, such a release
could easily be mistaken for beeing an actual date. Maybe better to
write 2008.r1.s1 to make it explicit it isn't the release date?
2008.r1.s1 would at a glance easily give me an impression on whether
the kernel version is "outdated", "mature" or "fresh".  2008.r1.s1 is
easily googlable (though googling for "linux changelog 2.6.25" isn't
really that difficult)

That being said, is it really reasonable to assume the linux kernel
will continue evolving gradually for all future?  In all software,
sometimes it is really needed to make some major changes, break
backward compatibility and decrease the stability - and that's what
the major version numbers are for.  I think saying "we'll never need
to change the major version number again" is roughly equivalent with
"the design of Linux 2.6 is perfect".  Or, maybe some years or decades
down the road we'll all upgrade to something with a different name
than Linux ;-)

-- 
Tobias Brox, 69°42'N, 18°57'E
