Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbZKMRZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbZKMRZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZKMRZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:25:17 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:52737 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752788AbZKMRZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:25:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqwEAMcg/UpGGN1W/2dsb2JhbACBTdRdhDwE
Date: Fri, 13 Nov 2009 12:25:17 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: LTTng 0.168 for kernel 2.6.31.6
Message-ID: <20091113172517.GA23922@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:14:08 up 87 days,  4:03,  4 users,  load average: 0.37, 0.39,
	0.36
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

LTTng 0.168 makes periodic flush energy-efficient, adds cpu idle
notifiers for x86_32, x86_64 to deal with periodic flush vs idle
interaction (other architectures are todo). Also fix a ltt-relay-vfs
file close bug, increase default vm_state channel subbuffer size, fix
ltt-ascii so it compiles after cleanup (ltt-ascii is still experimental,
will need to be adapted to new periodic flush scheme).

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
