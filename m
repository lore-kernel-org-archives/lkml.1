Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbYCMQJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbYCMQJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbYCMQJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:09:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755572AbYCMQJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:09:30 -0400
Date: Thu, 13 Mar 2008 09:07:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: pm_register() and pm_send_all()
Message-Id: <20080313090738.d85b4dfa.akpm@linux-foundation.org>
In-Reply-To: <21968.1205411497@redhat.com>
References: <20080312150042.96668bcd.akpm@linux-foundation.org>
	<21968.1205411497@redhat.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 12:31:37 +0000 David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > pm_send_all() has just a handful of callers:
> 
> What should be done instead of calling pm_send_all()?
> 

I don't know, and neither does Rafael.  Hopefully Pavel does?
