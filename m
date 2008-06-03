Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbYFCBxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbYFCBxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 21:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYFCBxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 21:53:30 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57999 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbYFCBxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 21:53:30 -0400
Date: Tue, 3 Jun 2008 03:53:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "tvrtko.ursulin" <tvrtko.ursulin@sophos.com>
Subject: Re: [Bug #10798] kbuild variable $(src) broken in 2.6.23-rc3?
Message-ID: <20080603015355.GA24564@uranus.ravnborg.org>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <UJSav77TyUB.A.glD.ArZQIB@albercik>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <UJSav77TyUB.A.glD.ArZQIB@albercik>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 07:48:06PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10798
> Subject		: kbuild variable $(src) broken in 2.6.23-rc3?
> Submitter	: tvrtko.ursulin <tvrtko.ursulin@sophos.com>
> Date		: 2008-05-21 14:42 (11 days old)
> References	: http://marc.info/?l=linux-kbuild&amp;m=121138246208259&amp;w=2
> Handled-By	: Sam Ravnborg <sam@ravnborg.org>

Fixed by: 96d97f262aa6120f8dd8e8e9c7a0b0677de7e29e ("kbuild: fix $(src)
assignmnet with external modules")

Bug is closed in bugzilla.

	Sam
