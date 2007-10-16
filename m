Return-Path: <linux-kernel-owner+w=401wt.eu-S935415AbXJPXDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935415AbXJPXDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755895AbXJPXDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:03:06 -0400
Received: from Toushirou.duckcorp.org ([193.200.42.177]:49431 "EHLO
	mx1.duckcorp.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbXJPXDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:03:05 -0400
From: Arnaud Fontaine <arnaud@andesi.org>
To: linux-kernel@vger.kernel.org
Subject: Re: error: Eeek! page_mapcount(page) went negative! (-1) with  different process and kernels
Organization: Andesi
References: <sa564176ksz.fsf@Toushirou.duckcorp.org>
	<20071016183510.GB25480@redhat.com>
X-URL: http://www.andesi.org
X-Operating-System: Debian GNU/Linux
X-GnuPG-KeyID: 5E3619D3
X-PGP-Fingerprint: D792 B8A5 A567 B001 C342  2613 BDF2 A220 5E36 19D3
Date: Wed, 17 Oct 2007 01:03:02 +0200
In-Reply-To: <20071016183510.GB25480@redhat.com> (Dave Jones's message of
	"Tue, 16 Oct 2007 14:35:10 -0400")
Message-ID: <sa5ejfu64t5.fsf@Toushirou.duckcorp.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Dave" == Dave Jones <davej@redhat.com> writes:

    Dave> Many of these that I've  seen have turned out to be a hardware
    Dave> problem.  Try running memtest86+  on that machine for a while.
    Dave>  It doesn't  catch all  problems, but  it will  highlight more
    Dave> common memory faults.

Hello,

We ran memtest86+ before production, it  was about one month ago. Do you
think it could come from that anyway?

Regards,
Arnaud Fontaine
