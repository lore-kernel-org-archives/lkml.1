Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZAIXzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZAIXzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZAIXyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:54:52 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:39131 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245AbZAIXyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:54:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtAEAFtvZ0lMQWjN/2dsb2JhbACBbM41hW8
Date: Fri, 9 Jan 2009 18:54:49 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: LTTng 0.73 for Linux 2.6.28
Message-ID: <20090109235449.GA21999@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:37:42 up 8 days, 23:35,  2 users,  load average: 0.90, 0.70,
	0.39
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I just ported LTTng to 2.6.28. Enjoy !

You may also want to upgrade to lttv 0.12.5 which puts back the syscall
and softirq names in the event list.

For newcomers, instructions to install LTTng can be found at :
http://ltt.polymtl.ca/svn/trunk/lttv/QUICKSTART

(I just updated the QUICKSTART guide. Please feel free to try it and
report inconsistencies.)

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
