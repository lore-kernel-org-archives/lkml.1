Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYLIVsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYLIVsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 16:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYLIVr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 16:47:57 -0500
Received: from kuber.nabble.com ([216.139.236.158]:33088 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbYLIVr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 16:47:57 -0500
Message-ID: <20924383.post@talk.nabble.com>
Date: Tue, 9 Dec 2008 13:47:56 -0800 (PST)
From: Dennis Hardy <dhardy@sogetthis.com>
To: linux-kernel@vger.kernel.org
Subject: Re: CIFS regression in 2.6.27.8
In-Reply-To: <20081209154932.0952fbf3@dhcp-100-2-144.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: dhardy@sogetthis.com
References: <20900699.post@talk.nabble.com> <84144f020812081128p6d1e2a55v69996a360e7f0e8f@mail.gmail.com> <200812082112.49468.rjw@sisk.pl> <20081209154932.0952fbf3@dhcp-100-2-144.bos.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I tried it on both i386 and x86_64 and had no problems. Is this client
> non-x86 by any chance?

Curious...my kernel is CONFIG_X86_32=y and CONFIG_X86=y, CONFIG_MK6=y.

Perhaps this could be an issue with the Windows Server side (Windows Home
Server, latest Windows SPs, etc.)  Maybe MSFT introduced some "improvement"
in a recent update that caused an incompatibility of some sort.  I can try
mounting some other Windows machines via CIFS from the 2.6.27.8 end and see
what happens, plus boot back to 2.6.27.6 and compare.


-- 
View this message in context: http://www.nabble.com/CIFS-regression-in-2.6.27.8-tp20900699p20924383.html
Sent from the linux-kernel mailing list archive at Nabble.com.

