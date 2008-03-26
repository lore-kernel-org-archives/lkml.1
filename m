Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbYCZIsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbYCZIsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 04:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYCZIry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 04:47:54 -0400
Received: from public.bindows.net ([66.135.40.169]:57203 "EHLO
	public.bindows.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYCZIrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 04:47:53 -0400
Message-ID: <47EA0DAF.70709@better.se>
Date: Wed, 26 Mar 2008 09:47:43 +0100
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
> 
> and see if the machine recovers?

The keyboard locked up immediately, and the Konsole window where I typed 
the command also locked up and had to be killed forcibly.

Marcus

