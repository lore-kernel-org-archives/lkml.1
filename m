Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbYAIXyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbYAIXyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbYAIXyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:54:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbYAIXyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:54:11 -0500
Date: Wed, 9 Jan 2008 23:53:49 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: devzero@web.de
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       chris.mason@oracle.com, linux-fsdevel@vger.kernel.org,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       "Bryn M. Reeves" <breeves@redhat.com>, Milan Broz <mbroz@redhat.com>,
       dm-devel@redhat.com, Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080109235349.GH3510@agk.fab.redhat.com>
Mail-Followup-To: devzero@web.de, Jens Axboe <jens.axboe@oracle.com>,
	linux-kernel@vger.kernel.org, chris.mason@oracle.com,
	linux-fsdevel@vger.kernel.org,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	"Bryn M. Reeves" <breeves@redhat.com>,
	Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com,
	Heinz Mauelshagen <mauelshagen@redhat.com>
References: <95637914@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95637914@web.de>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 12:43:19AM +0100, devzero@web.de wrote:
> oh, nice to see that this is still alive.

> at least i got no crashes and was able to mount and acess more than 300 iso-images with that.

> were there fixes/chances since then?

Little has changed for some time - mostly code cleanups and the occasional bug fix.

It's time to give it wider exposure, I think, and we'll find out how well it holds up.

Alasdair
-- 
agk@redhat.com
