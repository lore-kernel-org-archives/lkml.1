Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbYGPTad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbYGPTad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 15:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYGPTaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 15:30:22 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2333 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbYGPTaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 15:30:21 -0400
Date: Wed, 16 Jul 2008 14:48:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 2nd REVISED AGENDA -- Re: Linux Wireless Mini-Summit -- Ottawa --
	July 22, 2008
Message-ID: <20080716184803.GB3232@tuxdriver.com>
References: <20080709190915.GA8238@tuxdriver.com> <20080715182654.GA5969@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715182654.GA5969@tuxdriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I adjusted the times based on the schedule for lunch and coffee breaks
from the OLS crew.  I also adjusted the length of some slots, and
move the BoF/Break-Out/BarCamp section before adjourning for dinner.

I'm still looking for more/different topics and for people to
explicitly claim the ones on the list...speak up!

John

---

3rd Linux Wireless Summit
Les Suites Hotel, Byward Suite
Ottawa, Canada
22 July 2008

Proposed Agenda

0830	Meet & Greet

	Introductions and opening remarks

0900	Status Reports

	Overview of where things stand today

	- QoS/Multiqueue

	- 802.11n

	- spectrum management

	- Mesh mode (802.11s)

	- RF kill

	- driver status reports

1000	Break

1030	Current Work

	Short presentations/discussions about work in progress

	- access point mode

	- cfg80211/nl80211
		- time to push to replace WEXT?
		- tool enhancements and/or userland support?

	- regulatory enforcement (802.11d, CRDA)

	- encrypted management frames (802.11w)

	- virtual hardware (mac80211_hwsim)

	- WiMAX

1200	Vendor/Distro Round Table

	Representatives from hardware vendors and Linux distributions
	discuss issues around cooperation between themselves and the
	development community, what we are doing well, and what problems we
	are causing for each other.

1230	Lunch/Break (provided by HP)

1330	Future work

	Short presentations/discussions about work that has previously
	been suggested or requested

	- power management 
		- suspend/resume
		- power savings

	- lib80211 (code sharing w/ full MAC drivers)

	- rate scaling algorithms
		- minstrel
		- others?

	- userland MLME

	- userland driver implementation

	- organized testing (anyone have a proposal?)

1500	BoF/Break-out/BarCamp Session Proposals

1530	Break

1600	BoF/Break-out/BarCamp Sessions

	Impromptu and/or unscheduled discussions as desired by group
	participants

1730	BoF/Break-out/BarCamp Session Reports

1800	Maintainence Issues

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

1830	Adjourn

-- 
John W. Linville
linville@tuxdriver.com
