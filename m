Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbXK0HEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbXK0HEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 02:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbXK0HEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 02:04:37 -0500
Received: from mx12.go2.pl ([193.17.41.142]:54733 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751066AbXK0HEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 02:04:37 -0500
Date: Tue, 27 Nov 2007 08:09:12 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make I/O schedulers non-modular
Message-ID: <20071127070912.GB1735@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071125172237.GC6658@kernel.dk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-11-2007 18:22, Jens Axboe wrote:
> On Sun, Nov 25 2007, Adrian Bunk wrote:
...
>> Is there any technical reason why we need 4 different schedulers at all?
> 
> Until we have the perfect scheduler :-)

IMHO this is not enough yet. There is something called "the right
of choice", and, it seems, things are usually far from perfect
where this right is not respected.

Regards,
Jarek P.
