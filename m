Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbYDRGvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbYDRGvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbYDRGux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:50:53 -0400
Received: from main.gmane.org ([80.91.229.2]:46904 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbYDRGuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:50:52 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: 2.6.25: Reported regressions from 2.6.24
Date: Fri, 18 Apr 2008 08:50:37 +0200
Message-ID: <fu9gbt$ki9$1@ger.gmane.org>
References: <alpine.LFD.1.00.0804162009080.2879@woody.linux-foundation.org> <alpine.DEB.1.10.0804162120130.17133@asgard> <OWZNsD2DjtM.A.d_C.327BIB@albercik>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 0-086.vpn.rwth-aachen.de
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
In-Reply-To: <OWZNsD2DjtM.A.d_C.327BIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki schrieb:
> As promised, below is the list of reported regressions from 2.6.24 for which
> there are no fixes in 2.6.25, AFAICS.
> 
> I'm now going to start tracking regressions from 2.6.25, but bug #9832 used
> for tracking the regressions from 2.6.24 will stay there, so if you report
> a regression from 2.6.24 through the Bugzilla, please make it block that bug.

Got another regression:

Wakeup from ACPI S3 is broken in 2.6.25, x86_64, last known version is 
2.6.25-rc8git8. My Lenovo Laptop does not wake up from S3. I have no 
time to analyze this further now, but I will try to find out what 
happened later today, will open a bugzilla then.

