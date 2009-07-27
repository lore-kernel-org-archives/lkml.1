Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbZG0N0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbZG0N0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZG0N0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:26:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35115 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753751AbZG0N0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:26:21 -0400
Date: Mon, 27 Jul 2009 14:25:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zachary Amsden <zamsden@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, axboe@kernel.dk, hch@infradead.org,
       akpm@linux-foundation.org, Paul.Clements@steeleye.com, tytso@mit.edu,
       Tejun Heo <tj@kernel.org>, miklos <miklos@szeredi.hu>
Subject: Re: [PATCH] Allow userspace block device implementation
Message-ID: <20090727142536.465799aa@lxorguk.ukuu.org.uk>
In-Reply-To: <1248699365.6987.1628.camel@twins>
References: <4A6D79F6.3050509@redhat.com>
	<1248699365.6987.1628.camel@twins>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Somehow this made me think of FUSE/CUSE... should this be named aBUSE?
> Oh wait it is :-), what I'm after is I guess is, can we share some of
> the FUSE/CUSE code?

It reminds me of the existing and perfectly functional network block
device (nbd) we already have and which has also been present for years.

Alan
