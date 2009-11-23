Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZKWE4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZKWE4J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 23:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbZKWE4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 23:56:09 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:61852 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756157AbZKWE4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 23:56:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAP+fCUtGGN1W/2dsb2JhbACBTdFShDwE
Date: Sun, 22 Nov 2009 23:56:13 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.179 for Linux 2.6.32-rc8
Message-ID: <20091123045613.GA5266@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 23:52:42 up 96 days, 15:42,  3 users,  load average: 0.75, 0.37,
	0.29
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just released LTTng 0.179 for the Linux kernel 2.6.32-rc8. Only the
changes required to make it work on this kernel were made. Linux Kernel
Markers were re-added into the LTTng tree as a temporary measure until
we switch to TRACE_EVENT().

As always, the packages can be found at http://www.lttng.org

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
