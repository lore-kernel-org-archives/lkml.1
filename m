Return-Path: <linux-kernel-owner+w=401wt.eu-S1752047AbXA2SDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbXA2SDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 13:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXA2SDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 13:03:14 -0500
Received: from mail.suse.de ([195.135.220.2]:53277 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbXA2SDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 13:03:12 -0500
From: Andi Kleen <ak@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [patch] i386: add option to show more code in oops reports
Date: Mon, 29 Jan 2007 19:03:08 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>
References: <45B7C019.1040209@redhat.com> <200701290444.21861.ak@suse.de> <45BE1561.6000303@redhat.com>
In-Reply-To: <45BE1561.6000303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701291903.08739.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> This was patch inspired by my finding out that code in the running
> kernel might have
> been modified at runtime by some strange bug, and looking at vmlinux
> might not be
> helpful.

Hmm ok, although I still suspect in such a case you'll be better
off with a full kcrash dump.

-Andi
