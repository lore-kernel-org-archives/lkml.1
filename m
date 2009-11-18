Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbZKRFer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbZKRFer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 00:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZKRFeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 00:34:46 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:60068 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752242AbZKRFep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 00:34:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As4EAHIUA0tGGN1W/2dsb2JhbACBTtQahDsEgW8
Date: Wed, 18 Nov 2009 00:34:48 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@listsi.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.174
Message-ID: <20091118053448.GB4152@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 00:33:35 up 91 days, 16:23,  4 users,  load average: 0.08, 0.08,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng 0.174 adds missing del_timer to switch_timer (optional feature),
and fixes buggy mips32 trace clock.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
