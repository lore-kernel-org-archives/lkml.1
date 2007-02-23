Return-Path: <linux-kernel-owner+w=401wt.eu-S932145AbXBWLuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbXBWLuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbXBWLuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:50:25 -0500
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:49257 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbXBWLuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:50:23 -0500
Message-ID: <45DED4F6.3000801@s5r6.in-berlin.de>
Date: Fri, 23 Feb 2007 12:50:14 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.8) Gecko/20061030 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jiri Kosina <jikos@jikos.cz>, webmaster@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: gitweb on kernel.org buggy?
References: <Pine.LNX.4.64.0702222219520.10496@twin.jikos.cz> <45DE113D.1020606@zytor.com>
In-Reply-To: <45DE113D.1020606@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> gitweb on kernel.org is at least in part orphanned, since the "official" 
> gitweb maintainers don't seem to listen to us (kernel.org people) w.r.t. 
> some issues, mainly related to caching, we've had to fork gitweb and 
> maintain it ourselves -- however, since kernel.org is currently all 
> volunteer labor, we have limited amount of time in which to deal with 
> things.

A non-representative data point: 98.72% (give or take ten percent) of my
accesses to kernel.org hosted git repos is via gitweb --- even despite
its slowness, synchronization lag, and bug(s).

Would be nice if there was anybody familiar with issues concerning
high-volume gitweb serving who could contribute.
-- 
Stefan Richter
-=====-=-=== --=- =-===
http://arcgraph.de/sr/
