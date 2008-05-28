Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbYE1TiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbYE1TiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 15:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYE1TiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:38:15 -0400
Received: from exhub016-2.exch016.msoutlookonline.net ([207.5.72.164]:42545
	"EHLO EXHUB016-2.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484AbYE1TiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:38:15 -0400
Message-ID: <483DB49D.7040706@cfl.rr.com>
Date: Wed, 28 May 2008 15:38:05 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Gene Heskett <gene.heskett@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: floppy question of the hour
References: <200805232114.20937.gene.heskett@gmail.com> <4837DFC6.9010202@s5r6.in-berlin.de> <200805240852.58268.gene.heskett@gmail.com> <483C81DE.8060002@cfl.rr.com> <20080528134257.GA16164@csclub.uwaterloo.ca>
In-Reply-To: <20080528134257.GA16164@csclub.uwaterloo.ca>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> Just do what the Amiga did:  Read the entire track into a buffer in
> memory, then deal with the sectors, and write the entire track back. :)

IIRC, there is no way to detect the interleave factor that the media has 
been formatted with, unless you maybe try several and see which one 
reads fastest.


