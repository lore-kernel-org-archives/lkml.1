Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbXCUSRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbXCUSRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933322AbXCUSRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:17:48 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35905 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320AbXCUSRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:17:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: sukadev@us.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       David Chinner <dgc@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Jiri Slaby <jirislaby@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] 2.6.21-rc4-mm1: freezing of processes broken
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<1174446834.6665.3.camel@nigel.suspend2.net>
	<20070321142350.GB78@tv-sign.ru> <200703211545.17919.rjw@sisk.pl>
	<20070321082029.2a38e09f.akpm@linux-foundation.org>
	<20070321165534.GA476@tv-sign.ru>
	<20070321090824.38d67ce3.akpm@linux-foundation.org>
	<20070321180713.GA27575@us.ibm.com>
Date: Wed, 21 Mar 2007 12:16:22 -0600
In-Reply-To: <20070321180713.GA27575@us.ibm.com> (sukadev@us.ibm.com's message
	of "Wed, 21 Mar 2007 11:07:13 -0700")
Message-ID: <m1bqimbgy1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


While we are on the topic.  What became of the notion of zeroing the
session and process group values for the init_task?

Eric
