Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbZKRPR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbZKRPR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 10:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbZKRPR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 10:17:58 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:52909 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752303AbZKRPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 10:17:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As4EAAuaA0tGGN1W/2dsb2JhbACBTdRmhDsE
Date: Wed, 18 Nov 2009 10:18:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: LTTng 0.175 (bugfix)
Message-ID: <20091118151802.GA21352@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:16:32 up 92 days,  2:06,  5 users,  load average: 0.36, 0.23,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just released LTTng 0.175, which fixes a bug introduced very recently
in the event ID compactor. Given it only runs after a trace session
ends, the problem only shows up when taking a second trace (or more)
after bootup.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
