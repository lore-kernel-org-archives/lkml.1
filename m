Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbXEJUtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbXEJUtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbXEJUtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:49:46 -0400
Received: from web60012.mail.yahoo.com ([209.73.178.75]:45858 "HELO
	web60012.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755344AbXEJUtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:49:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ap8xbJ4hLcEzhMboSqq1vmZ2Te7qblKs4+jGbQb3Tb4FXDYRmxchOxsOFrqQp5DQOBngyxsbtxQikRcYK3r6EPpZVJUgiQHHWIpuMfnNXcNvOau/ypRA1dziEUT2P55aOq4sfgpeyCjx+iSjymQ/obhkn6mUEFMgpbcrf3uxopE=;
X-YMail-OSG: FlacW6EVM1nWtIhZlgFmpZYpT2Lh0ndT64qvTNrLtVTICGZ2UXrk5hHRbv439zqnXNunSncvXYIMRsmXKx7OjXyxQE4FHqf0nY36Crj1rCdtE_ufDcVwYV1ys59jMPM-
Date: Thu, 10 May 2007 13:49:45 -0700 (PDT)
From: Charles Gagalac <charle97@yahoo.com>
Reply-To: charle97@yahoo.com
Subject: Re: [Bugme-new] [Bug 8462] New: applications under wine freezes
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705101150340.18318@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <72664.35032.qm@web60012.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Davide Libenzi <davidel@xmailserver.org> wrote:

> Thank you Charles. Would you mind giving the patch
> below a try?
> 

i applied the patch and i'm still encountering
freezing problems with starcraft, pokerstars, and
firefox under wine.

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
