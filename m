Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbYGITiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYGITiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYGITiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:38:04 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3149 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbYGITiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:38:03 -0400
Date: Wed, 9 Jul 2008 15:09:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
Message-ID: <20080709190915.GA8238@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The third Linux Wireless mini-summit will occur on Tuesday July 22,
2008 in Ottawa, just before the Ottawa Linux Symposium.  OLS is
generously supporting Linux mini-summits by providing the room and
projector (http://www.linuxsymposium.org/2008/minisummits.php).
Several vendors are supporting the event by sponsoring their own
employees to attend, and Canonical and Intel have both helped with
travel funds for key community participants as well.

Although it is already a bit late, I would like to re-open discussions
on our agenda for the meeting.  Based on current upstream topics and
those persons whom I expect to be attending, I have cobbled together
an agenda proposal below.  Please review it and feel free to suggest
amendments or alterations, or to elaborate or ask questions about my
proposed schedule of topics.

I look forward to seeing many of you in Ottawa!

John

P.S.  If you intend to attend the event in Ottawa, please send me a
private reply to this note -- even if you believe that I already know
that you are coming! :-)

---

3rd Linux Wireless Summit
Ottawa, Canada
22 July 2008

Proposed Agenda

0830	Meet & Greet

	Introductions and opening remarks

0900	Status Reports

	Overview of where things stand today

	- 802.11n

	- QoS/Multiqueue

	- Mesh mode (802.11s)

	- RF kill

1015	Break

1100	Vendor/Distro Round Table

	Representatives from hardware vendors and Linux distributions
	discuss issues around cooperation between themselves and the
	development community, what we are doing well, and what problems we
	are causing for each other.

1200	Lunch/Break (sorry, no funding)

1300	Current Work

	Short presentations/discussions about work in progress

	- encrypted management frames (802.11w)

	- regulatory enforcement (802.11d, CRDA)

	- virtual hardware (mac80211_hwsim)

1445	Break

1500	Future work

	Short presentations/discussions about work that has previously
	been suggested or requested

	- cfg80211/nl80211
		- time to push to replace WEXT?
		- tool enhancements and/or userland support?

	- power management (suspend/resume)

	- lib80211 (code sharing w/ full MAC drivers)

	- rate scaling algorithms
		- minstrel
		- others?

	- userland MLME

	- userland driver implementation

1645	Break

1700	Maintainence Issues

	Round table discussion of issues related to maintenance of
	the wireless trees

	- trivial/cleanup patches
		- testing or other requirements?
		- should they have lower priority?
		- should they require ACKs from primary author?

	- submissions to -stable
		- who should drive it?
		- what policies?

	- rate scaling algs
		- driver-specific ok?  what limitations?
		- build policies (part of mac80211.ko?)

	- questions/suggestions/complaints

1800	Dinner/Break (sorry, no funding)

2000	BoF/Break-out Sessions

	Impromptu and/or unscheduled discussions as desired by group
	participants

-- 
John W. Linville
linville@tuxdriver.com
