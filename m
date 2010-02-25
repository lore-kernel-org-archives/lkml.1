Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab0BYEN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 23:13:58 -0500
Received: from mail.vyatta.com ([76.74.103.46]:41882 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab0BYEN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 23:13:56 -0500
Date: Wed, 24 Feb 2010 20:13:41 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: netdev@vger.kernel.org, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2-2.6.33 version
Message-ID: <20100224201341.338dd71f@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New version of iproute2 utilities that includes bug fixes and
support for all the new features in kernel 2.6.33. This integrates
a number of minor bug fixes from Debian as well.

Source: (note old developer.osdl.org address works as well)
	http://devresources.linux-foundation.org/dev/iproute2/download/iproute2-2.6.33.tar.bz2

Git tree:
	git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

Changes since v.2.6.31:

Alex Badea (2):
      ip xfrm state: parse and print "icmp" and "af-unspec" flags
      ip xfrm policy: allow different tmpl family

Alexandre Cassen (1):
      IPv6: 6rd iproute2 support

Andreas Henriksson (2):
      iproute2: avoid using bashisms in configure script.
      iproute2: drop equalize support

Arnd Bergmann (1):
      iproute2/iplink: add macvlan options for bridge mode

Brian Haley (2):
      Add dadfailed option to ip command
      ip: print "temporary" for IPv6 temp addresses

Florian Westphal (5):
      tc: man: add limit parameter to tc-sfq man page
      tc: man: SO_PRIORITY is described in socket documentation, not tc one
      tc: red, gred, tbf: more helpful error messages
      tc: remove stale code
      tc: man: add man page for drr scheduler

Jamal Hadi Salim (1):
      skbedit: Add support to mark packets

Mike Frysinger (1):
      tc: respect LDFLAGS for %.so targets

Patrick McHardy (2):
      iplink_vlan: add support for VLAN loose binding flag
      iprule: add oif classification support

Stephen Hemminger (3):
      Update exported kernel headers
      iproute2-100205
      iproute2-10224

