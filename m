Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbXH1N1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbXH1N1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbXH1N13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:27:29 -0400
Received: from rwcrmhc13.comcast.net ([216.148.227.153]:43337 "EHLO
	rwcrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbXH1N12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:27:28 -0400
From: "Michael J. Evans" <mjevans1983@comcast.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [patch v3 1/1] md: Software Raid autodetect dev list not array
Date: Tue, 28 Aug 2007 06:26:32 -0700
User-Agent: KMail/1.9.7
Cc: Michael Evans <mjevans1983@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Neil Brown <neilb@suse.de>,
       Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200708222058.45480.mjevans1983@comcast.net> <4877c76c0708280608m529296edgd83f9c08e3918815@mail.gmail.com> <Pine.LNX.4.64.0708281511470.3018@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708281511470.3018@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708280626.32975.mjevans1983@comcast.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 August 2007, Jan Engelhardt wrote:
> 
> On Aug 28 2007 06:08, Michael Evans wrote:
> >
> >Oh, I see.  I forgot about the changelogs.  I'd send out version 5
> >now, but I'm not sure what kernel version to make the patch against.
> >2.6.23-rc4 is on kernel.org and I don't see any git snapshots.
> 
> 2.6.23-rc4 is a snapshot in itself, a tagged one at that.
> Just use git pull to get the latest, which is always good.
> Or git fetch; git checkout 2.6.23-rc4; if you need that particular one.
> 
> >Additionally I never could tell what git tree was the 'mainline' as it
> >isn't labeled with such a keyword (at least in the list of git trees I
> >saw).
> 
> /torvalds/linux-2.6.git or so; yes, it's not clearly marked. Then again, 
why?
> /Mainline is tarballs for most people, and they don't want to go deeper ;-)
> 
> 
> 	Jan
> -- 
> 

Thank you, I'll try to keep that in mind the next time I try to use git.
