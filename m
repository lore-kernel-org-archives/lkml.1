Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbZA2M1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbZA2M1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 07:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZA2M1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 07:27:31 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:22976 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351AbZA2M1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 07:27:30 -0500
Message-ID: <4981A0AC.5030300@msgid.tls.msk.ru>
Date: Thu, 29 Jan 2009 15:27:24 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Xiaoning Ding <dingxn@ymail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: a question about p4_clockmod module on Xeon quad core	processors
References: <603382.20833.qm@web59902.mail.ac4.yahoo.com> <20090128210200.GA19527@redhat.com>
In-Reply-To: <20090128210200.GA19527@redhat.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
[]
> p4-clockmod doesn't change the processor frequency.

Hmm..  But what it really does, then?
I used it one one machine which had a flaky CPU cooler,
to reduce power consumption during hot summer days.
It worked, and reportedly the frequency varied from
200MHz to the max of 2.4GHz (it's a P4 Xeon).  Now
I wonder why it helped to reduce the temperature and
why the system reported different frequencies...

Thanks!

> Because of common misconceptions like this, the user interface has been removed.


/mjt
