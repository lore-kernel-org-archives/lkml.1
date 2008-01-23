Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbYAWOwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbYAWOwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYAWOwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:52:14 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:41373 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbYAWOwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:52:14 -0500
Date: Wed, 23 Jan 2008 17:51:49 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: roland@redhat.com
Cc: utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Bunch of utrace crashes
Message-ID: <20080123145149.GC6044@localhost.sw.ru>
References: <20080123144837.GB6044@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123144837.GB6044@localhost.sw.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	do_notify_resume
> 	get_signal_to_deliver
> 	tracehook_get_signal
> 	utrace_get_signal
> 	[utrace pointer found, utrace->lock taken]
					"not taken", of course.
> 	utrace_quiescent

