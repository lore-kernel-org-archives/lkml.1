Return-Path: <linux-kernel-owner+w=401wt.eu-S1760428AbZFJRPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbZFJRPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbZFJRPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:15:39 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:41722 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZFJRPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:15:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroEADODL0pMQW1W/2dsb2JhbACBT89PhA0F
Date: Wed, 10 Jun 2009 13:12:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: LTTng 0.140 for Linux 2.6.30
Message-ID: <20090610171203.GA29555@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:06:30 up 102 days, 13:32,  6 users,  load average: 1.32, 2.02,
	1.38
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just released LTTng 0.140 for the new kernel of the day. There were
very few conflicts to resolve since the 2.6.30-rc5 version. None in the
tracer "driver" part, only few in the overall kernel instrumentation.

Provided as-is, given my main test machine is currently busy running
some formal verification. It builds fine though.

As always, available on the kernel.org lttng tree and as a patchset. See
http://www.lttng.org for details.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
