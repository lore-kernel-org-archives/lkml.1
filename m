Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYGJGmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYGJGmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 02:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbYGJGmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 02:42:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:64604 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbYGJGl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 02:41:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cOgvxiVB1WXyHZJ5sobHZ0xwlaGthuboNiGQpWd1yITmYhWEwwVWvusjrqrokFpmR2
         Bihi6jCWb32qX4cJ8B0AEWWg/Rymu5pzRiaym03DBnaHfjPm7Pm+0PYZnkvfY0XY0rGz
         VVW3WI125yRuzu3QHnm718A9MO2yxJEUAmmv4=
Message-ID: <dac45060807092341u948e468r97fb652653ddb200@mail.gmail.com>
Date: Thu, 10 Jul 2008 09:41:45 +0300
From: "Mark Ryden" <markryde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080709190915.GA8238@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709190915.GA8238@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
 Linux wireless is, without any doubt, a very important subject.
Many people show interest in it.

It is good to hear that the third Linux Wireless mini-summit will
occur at OLS, which will give opportunity to  many people (which some
of them don't know much about linux wireless) to attend it (whereas
the two last wireless mini-summits were not part of OLS, as far as I
know).

I want to add that It would be great if part of it (or hopefully, all
of it) will be videoed and put on the web. I am sure that many
(including me) will be glad to watch it. I am sure that making an
effort like this is important and is of interest for the linux
wireless community.

Regards,
Mark Ryden


On Wed, Jul 9, 2008 at 10:09 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> The third Linux Wireless mini-summit will occur on Tuesday July 22,
> 2008 in Ottawa, just before the Ottawa Linux Symposium.  OLS is
> generously supporting Linux mini-summits by providing the room and
> projector (http://www.linuxsymposium.org/2008/minisummits.php).
> Several vendors are supporting the event by sponsoring their own
> employees to attend, and Canonical and Intel have both helped with
> travel funds for key community participants as well.
>
> Although it is already a bit late, I would like to re-open discussions
> on our agenda for the meeting.  Based on current upstream topics and
> those persons whom I expect to be attending, I have cobbled together
> an agenda proposal below.  Please review it and feel free to suggest
> amendments or alterations, or to elaborate or ask questions about my
> proposed schedule of topics.
>
> I look forward to seeing many of you in Ottawa!
>
> John
>
> P.S.  If you intend to attend the event in Ottawa, please send me a
> private reply to this note -- even if you believe that I already know
> that you are coming! :-)
>
> ---
>
> 3rd Linux Wireless Summit
> Ottawa, Canada
> 22 July 2008
>
> Proposed Agenda
>
> 0830    Meet & Greet
>
>        Introductions and opening remarks
>
> 0900    Status Reports
>
>        Overview of where things stand today
>
>        - 802.11n
>
>        - QoS/Multiqueue
>
>        - Mesh mode (802.11s)
>
>        - RF kill
>
> 1015    Break
>
> 1100    Vendor/Distro Round Table
>
>        Representatives from hardware vendors and Linux distributions
>        discuss issues around cooperation between themselves and the
>        development community, what we are doing well, and what problems we
>        are causing for each other.
>
> 1200    Lunch/Break (sorry, no funding)
>
> 1300    Current Work
>
>        Short presentations/discussions about work in progress
>
>        - encrypted management frames (802.11w)
>
>        - regulatory enforcement (802.11d, CRDA)
>
>        - virtual hardware (mac80211_hwsim)
>
> 1445    Break
>
> 1500    Future work
>
>        Short presentations/discussions about work that has previously
>        been suggested or requested
>
>        - cfg80211/nl80211
>                - time to push to replace WEXT?
>                - tool enhancements and/or userland support?
>
>        - power management (suspend/resume)
>
>        - lib80211 (code sharing w/ full MAC drivers)
>
>        - rate scaling algorithms
>                - minstrel
>                - others?
>
>        - userland MLME
>
>        - userland driver implementation
>
> 1645    Break
>
> 1700    Maintainence Issues
>
>        Round table discussion of issues related to maintenance of
>        the wireless trees
>
>        - trivial/cleanup patches
>                - testing or other requirements?
>                - should they have lower priority?
>                - should they require ACKs from primary author?
>
>        - submissions to -stable
>                - who should drive it?
>                - what policies?
>
>        - rate scaling algs
>                - driver-specific ok?  what limitations?
>                - build policies (part of mac80211.ko?)
>
>        - questions/suggestions/complaints
>
> 1800    Dinner/Break (sorry, no funding)
>
> 2000    BoF/Break-out Sessions
>
>        Impromptu and/or unscheduled discussions as desired by group
>        participants
>
> --
> John W. Linville
> linville@tuxdriver.com
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
