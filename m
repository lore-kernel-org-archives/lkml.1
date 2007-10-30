Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbXJ3Dhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbXJ3Dhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 23:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbXJ3DhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 23:37:24 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:54498 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbXJ3DhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 23:37:22 -0400
X-Greylist: delayed 829 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 23:37:22 EDT
Message-ID: <4726A6EC.6070407@nttdata.co.jp>
Date: Tue, 30 Oct 2007 12:37:16 +0900
From: Toshiharu Harada <haradats@nttdata.co.jp>
Organization: NTT DATA CORPORATION
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>,
       Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to	static
 interface)
References: <20071024223124.GI30533@stusta.de> <446110.89443.qm@web36608.mail.mud.yahoo.com> <20071024233200.GJ30533@stusta.de> <alpine.LFD.0.999.0710241636010.30120@woody.linux-foundation.org> <20071025004128.GC3660@sequoia.sous-sol.org>
In-Reply-To: <20071025004128.GC3660@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2007 03:37:18.0828 (UTC) FILETIME=[2C2FC2C0:01C81AA6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2007 9:41 AM, Chris Wright wrote:
> * Linus Torvalds (torvalds@linux-foundation.org) wrote:
>> Do other people want to stand up and be "LSM maintainers" in the sense 
>> that they also end up being informed members who can also stand up for new 
>> modules and help merge them, rather than just push the existing one(s)? 
>> Chris? Casey? Crispin?
> 
> Stephen and James, despite their clear bias towards SELinux, do try to
> give good feedback.  But you are right, there's not enough active help
> for people trying to make a contribution to get their code in shape.
> Many of the modules that come along have been misguided conceptually,
> but I think that e.g. apparmor, tomoyo, smack could use that kind
> of constructive help to get into final mergable shape.  Personally,
> I haven't spent nearly enough time reviewing those, my apologies to
> those developers.  So, yes, help is welcome.

Yes, TOMOYO Linux is committed to help.
I mean, please count me in.

PS
Chris, I've been waiting for your comments for our code. :)

Regards,
Toshiharu Harada

