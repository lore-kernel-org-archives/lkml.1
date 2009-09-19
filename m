Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbZISBZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbZISBZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 21:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbZISBZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 21:25:27 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:37745
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbZISBZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 21:25:27 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] Perl removal patches for 2.6.31
Date: Fri, 18 Sep 2009 20:25:28 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; x86_64; ; )
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909182025.29063.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perl dependencies were introduced into the build system in 2.6.25.  This 
removes the central ones preventing a bootable kernel from building without 
perl.

For the record, the perl removal patches I submitted for 2.6.30, still work 
fine (they apply with offsets).  Here are versions that apply without offsets to 
2.6.31.

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds

