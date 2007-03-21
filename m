Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbXCUSX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbXCUSX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbXCUSX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:23:58 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59868 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339AbXCUSXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:23:41 -0400
Date: Wed, 21 Mar 2007 11:23:37 -0700
From: sukadev@us.ibm.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       David Chinner <dgc@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Jiri Slaby <jirislaby@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] 2.6.21-rc4-mm1: freezing of processes broken
Message-ID: <20070321182337.GA28698@us.ibm.com>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <1174446834.6665.3.camel@nigel.suspend2.net> <20070321142350.GB78@tv-sign.ru> <200703211545.17919.rjw@sisk.pl> <20070321082029.2a38e09f.akpm@linux-foundation.org> <20070321165534.GA476@tv-sign.ru> <20070321090824.38d67ce3.akpm@linux-foundation.org> <20070321180713.GA27575@us.ibm.com> <m1bqimbgy1.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bqimbgy1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:
| 
| While we are on the topic.  What became of the notion of zeroing the
| session and process group values for the init_task?

I just sent that patch a few minutes ago.

| 
| Eric
