Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbXKROta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbXKROta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 09:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbXKROtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 09:49:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:34567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbXKROtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 09:49:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UlKIA6riCHRVyWPLaQBE4Qbquj7RfBnUmsGZ3kXheMEVWqVEWX4wHTEJH6XBGlCR7k6SzwbDK4UqO7mi+fjTa4da319I+v8Ujn6viO2k22PLn88KhepU49S6/D/9nvRTxeJAi8xcZqe3fbI5qYLSUl7DZ2qvFbSpMjzFWPwtE6s=
Message-ID: <474050EC.5080507@gmail.com>
Date: Sun, 18 Nov 2007 15:49:16 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
References: <Pine.LNX.4.44L0.0711171649100.7748-100000@netrider.rowland.org> <200711181442.09917.rjw@sisk.pl> <474043EC.4000700@gmail.com> <200711181603.26522.rjw@sisk.pl>
In-Reply-To: <200711181603.26522.rjw@sisk.pl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2007 04:03 PM, Rafael J. Wysocki wrote:
> Can you also make the new System-map available, please?

Sure:
http://www.fi.muni.cz/~xslaby/sklad/System.map1
