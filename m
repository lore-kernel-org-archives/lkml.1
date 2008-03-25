Return-Path: <linux-kernel-owner+w=401wt.eu-S1761892AbYCYWEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761892AbYCYWEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761524AbYCYWEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:04:23 -0400
Received: from public.bindows.net ([66.135.40.169]:53506 "EHLO
	public.bindows.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761470AbYCYWEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:04:22 -0400
X-Greylist: delayed 1215 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2008 18:04:21 EDT
Message-ID: <47E9721C.2000306@better.se>
Date: Tue, 25 Mar 2008 22:43:56 +0100
From: Marcus Better <marcus@better.se>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10327] New: keyboard stops responding after
 "ifdown eth0"
References: <bug-10327-10286@http.bugzilla.kernel.org/> <20080325143941.300d415f.akpm@linux-foundation.org>
In-Reply-To: <20080325143941.300d415f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Perhaps you could try
> 
> 	ifdown eth0 ; sleep 5 ; ifup eth0

Will try. There is also a Debian bug report of the same or a similar 
problem with kernels from 2.6.18:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=415147

