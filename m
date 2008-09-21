Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbYIUUt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbYIUUt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYIUUjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:39:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:17664 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbYIUUjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:39:13 -0400
Message-ID: <f488382f0809211339i250defb9obf82d218a03beb44@mail.gmail.com>
Date: Sun, 21 Sep 2008 13:39:11 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11551] Semi-repeatable hard lockup on 2.6.27-rc6
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <7lIhZC4hCxE.A.uuG.a0q1IB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
	 <7lIhZC4hCxE.A.uuG.a0q1IB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 11:54 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11551
> Subject         : Semi-repeatable hard lockup on 2.6.27-rc6
> Submitter       : Steven Noonan <steven@uplinklabs.net>
> Date            : 2008-09-10 18:07 (12 days old)
> References      : http://marc.info/?l=linux-kernel&m=122107007407994&w=4
>
>

The machine with these symptoms was sent in for service on Friday. I
suspect there may have been dodgy hardware involved on this one. I
think this bug should be closed for the time being. Once I get the
machine back, I'll reopen the bug if I can still reproduce it.

- Steven
