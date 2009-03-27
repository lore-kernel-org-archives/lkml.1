Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbZC0N6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbZC0N6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 09:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZC0N6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 09:58:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45232 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752420AbZC0N6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 09:58:02 -0400
Date: Fri, 27 Mar 2009 13:56:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Bron Gondwana <brong@fastmail.fm>, Matthew Garrett <mjg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090327135645.50171983@lxorguk.ukuu.org.uk>
In-Reply-To: <20090327121952.GB30410@brong.net>
References: <20090326140312.GB14822@elte.hu>
	<20090326144707.GA6239@mit.edu>
	<alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>
	<20090326170714.GF6239@mit.edu>
	<alpine.LFD.2.00.0903261015050.3032@localhost.localdomain>
	<20090326185900.166a1097@lxorguk.ukuu.org.uk>
	<20090326200258.GA10313@srcf.ucam.org>
	<20090326204209.1da6e791@lxorguk.ukuu.org.uk>
	<20090326230435.GA10884@brong.net>
	<20090327112248.2746a4ba@lxorguk.ukuu.org.uk>
	<20090327121952.GB30410@brong.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bron ( ok, I'm getting a bit silly here

Yes you are - completely.
