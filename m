Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbZEWLSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbZEWLSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 07:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZEWLSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 07:18:35 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:46433 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZEWLSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 07:18:34 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Sat, 23 May 2009 06:18:30 -0500
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <4A1748A9.1020306@zytor.com> <200905230544.54657.lkml@morethan.org>
In-Reply-To: <200905230544.54657.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905230618.34071.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat May 23 2009, Michael S. Zick wrote:
> On Fri May 22 2009, H. Peter Anvin wrote:
> > Michael S. Zick wrote:
> > > Same integrated motherboard.
> > 
> > Which means same CPU, same BIOS, same motherboard (none of which you're
> > telling us.)
> > 
> 
> The only objective information is posted here:
> http://lkml.org/lkml/2009/5/20/342
> Everything else related to this problem is subjective.
> 
> > cpuinfo and dmidecode would be informative.
> > 
> 
> Must have hit "reply" rather than "reply all" at some
> critical point along the way.
> 
> Browse this directory:
> http://hp-umpc.com/ce1200v/
> Your looking for the:
> http://hp-umpc.com/ce1200v/sylvania-g-data.tar.gz
> The Everex Cloudbook only varies by some strings in the 
> dmidecode output.
> 
> For logs of speculation and efforts at re-arranging the
> deck chairs on the Titanic:
> http://forum.netbookuser.com/viewforum.php?id=8
> 
> I chose to start with the ce1200v because:
> *) It needs the most help;
> *) One of the two tech manuals on the cx700 has been
> published since the drivers where touched.
> see: http://linux.via.com.tw/support/downloadFiles.action
> select cx700/vx700 in right-hand box, click the manual.
> *) The HP-2133 MiniNote uses the cn896 chipset, which
> has not yet been released from NDA.
> 
> Note:
> I do not have the C7-M technical reference, it is still
> under NDA.
> *But* if a developer on this list has a copy of the
> manual *and* owns one of these three brands of machine -
> they would have fixed their own machine a year ago.
> So I am not holding my breath until a person is located
> that has both the manual and the machine.  ;)
> 

As to getting a person with the manuals on-hand and everyone
else together, may I point out that the MUC room is still on-line:

Pick you favorite Jabber MUC client;
JID: cloudbook-group@conference.jabber.cb-chat.com

Which translates to:
Room: cloudbook-group
URL: conference.jabber.cb-chat.com
Password: <none> leave blank in your client, it is a public room.

Note: This is a low-volume server and has "on-demand" rooms enabled;
you want a room for the "hot topic" of the moment;
just "join chat" or "join group" (whatever your client calls it) for
the new room name - the server will create it for you.

If creating rooms, I strongly suggest Gajim - it has the easiest to
use control and administrative features.

Note2: Not using any video, so we will not see your smiling face. ;)

Mike
> Mike
> 
> 
> > 	-hpa
> > 
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


