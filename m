Return-Path: <linux-kernel-owner+w=401wt.eu-S1760352AbXJEOSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760352AbXJEOSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 10:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbXJEOSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 10:18:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:55537 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751495AbXJEOSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 10:18:11 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18uFP9T/0sudLftdsG+vXesySS6bawEHLQLZfMfYd
	89svbXTljp1wik
Date: Fri, 5 Oct 2007 16:18:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: linux-pm@lists.linux-foundation.org
Subject: [Q] APM depends on PM_SLEEP?
Message-ID: <Pine.LNX.4.60.0710051615350.10392@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Why does APM depend on PM_SLEEP? So without sleep support you cannot use 
"Make CPU Idle calls when idle ", "Use real mode APM BIOS call to power 
off" etc? Found in 23-rc9-git of yesterday.

Thanks
Guennadi
---
Guennadi Liakhovetski
