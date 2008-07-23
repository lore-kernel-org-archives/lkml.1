Return-Path: <linux-kernel-owner+w=401wt.eu-S1752384AbYGWJED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbYGWJED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 05:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbYGWJDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 05:03:43 -0400
Received: from anguilla.debian.or.at ([86.59.118.152]:43434 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbYGWJDl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 05:03:41 -0400
Date: Wed, 23 Jul 2008 11:03:40 +0200
From: Peter Palfrader <peter@palfrader.org>
To: Ilpo =?iso-8859-15?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Adam Langley <agl@imperialviolet.org>, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.25.6: warn_on_slowpath in tcp_input.c
Message-ID: <20080723090340.GQ18443@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	Ilpo =?iso-8859-15?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
	Adam Langley <agl@imperialviolet.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Netdev <netdev@vger.kernel.org>
References: <20080630230954.GS16698@anguilla.noreply.org> <396556a20806301656ydc44e3ey6deb229ab69904@mail.gmail.com> <20080701073833.GT16698@anguilla.noreply.org> <Pine.LNX.4.64.0807171744130.13775@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <Pine.LNX.4.64.0807171744130.13775@wrl-59.cs.helsinki.fi>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Ilpo Järvinen wrote:
> > > > I've had 13 or so of them since upgrading the machine to a 2.6.25 kernel
> > > > 20 days ago.
> > > >
> > > > Linux saens 2.6.25.6-dl380 #2 SMP Tue Jun 10 17:54:44 CEST 2008 i686 GNU/Linux
> 
> Thanks for the report, I've been away for a while, thus the late response.
> Please update to get this relevant fix and some other TCP fixes (if you 
> haven't yet):
> 
>  releases/2.6.25.7/tcp-fix-skb-vs-fack_count-out-of-sync-condition.patch
> 
> ...If you still get them afterwards, please do rereport (and include me 
> as recipient :-)).

Running 2.6.25.11 since a couple of days ago now.  Looking good, thanks.

-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
