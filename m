Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbZGAVwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbZGAVwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZGAVwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:52:15 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:60092 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754982AbZGAVwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:52:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqcFADdyS0pMQWU3/2dsb2JhbACBUc8JhBEF
Date: Wed, 1 Jul 2009 17:52:17 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: LTTng 0.142 for kernel 2.6.30
Message-ID: <20090701215217.GA22220@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:49:45 up 123 days, 18:15,  4 users,  load average: 1.16, 0.51,
	0.39
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I'm pleased to announce that LTTng 0.142 includes a fix to text poke
even before it gets to the -stable tree. See my post here for details.

http://lkml.org/lkml/2009/7/1/491

(no other change in this release, only this fix)

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
