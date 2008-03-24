Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYCXX2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYCXX2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYCXX17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:27:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760AbYCXX17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:27:59 -0400
Date: Mon, 24 Mar 2008 16:26:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: pavel@ucw.cz, ebiederm@xmission.com, xemul@openvz.org, sds@tycho.nsa.gov,
       roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-Id: <20080324162659.89deedad.akpm@linux-foundation.org>
In-Reply-To: <20080324231859.GA193@tv-sign.ru>
References: <20080323135110.GA294@tv-sign.ru>
	<20080324160102.GB4069@atrey.karlin.mff.cuni.cz>
	<20080324164059.GA4767@tv-sign.ru>
	<20080324223925.GD2426@elf.ucw.cz>
	<20080324230458.GA173@tv-sign.ru>
	<20080324230930.GE2426@elf.ucw.cz>
	<20080324231859.GA193@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008 02:18:59 +0300
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> Please look at another discussion, http://marc.info/?t=120568298600007

-EAMTOOLAZY.  Whatever is at the above link should be in the changelog so we
can understand the reasons for the patch!

Please.
