Return-Path: <linux-kernel-owner+w=401wt.eu-S1758491AbZCCHqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491AbZCCHqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 02:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZCCHqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 02:46:13 -0500
Received: from viefep17-int.chello.at ([62.179.121.37]:22586 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZCCHqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 02:46:12 -0500
X-SourceIP: 213.93.53.227
Subject: Re: lockdep and threaded IRQs (was: ...)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Brownell <david-b@pacbell.net>
Cc: dbrownell@users.sourceforge.net, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
In-Reply-To: <200903021529.07894.david-b@pacbell.net>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	 <200903021440.58712.david-b@pacbell.net>
	 <1236034289.5330.1745.camel@laptop>
	 <200903021529.07894.david-b@pacbell.net>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 08:45:42 +0100
Message-Id: <1236066342.18955.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 15:29 -0800, David Brownell wrote:

> That patch did no such thing.  It added a BUG_ON(),
> which has nothing to do with removing IRQF_DISABLED.

http://lkml.org/lkml/2009/3/2/33


