Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbZKQCcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbZKQCcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 21:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZKQCcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 21:32:23 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:41894 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbZKQCcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 21:32:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAMOYAUtGGN1W/2dsb2JhbACBS9YdhDwE
Date: Mon, 16 Nov 2009 21:32:24 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org, pierre-marc.fournier@polymtl.ca,
       william.bourque@polymtl.ca
Subject: [RELEASE] LTTng 0.171 and LTTV 0.12.21 (trace format 2.4)
Message-ID: <20091117023224.GA20305@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 21:23:29 up 90 days, 13:13,  4 users,  load average: 0.98, 0.46,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just released LTTng 0.171 and LTTV 0.12.21, which move the trace
format to 2.4 (therefore not compatible with older versions).

The reason:

"Do not limit alignment on architecture size anymore, because uint64_t
types are aligned on 64-bit even on 32-bit archs. It's a waste of space
for 32-bit architectures, but makes our format compatible with gcc."

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
