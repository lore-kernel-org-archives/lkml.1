Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbZGHQI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbZGHQI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759435AbZGHQGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:06:25 -0400
Received: from fifo99.com ([67.223.236.141]:50615 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759440AbZGHQGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:06:24 -0400
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
From: Daniel Walker <dwalker@fifo99.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tarkan Erimer <tarkan.erimer@turknet.net.tr>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <1247063244.4159.40.camel@mulgrave.site>
References: <4A4CB4B4.5010307@turknet.net.tr>
	 <20090702130728.22af524c.akpm@linux-foundation.org>
	 <8db1092f0907080609w60e37ac0id49a44bd4796b425@mail.gmail.com>
	 <1247063244.4159.40.camel@mulgrave.site>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 09:06:18 -0700
Message-Id: <1247069178.5973.6.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 09:27 -0500, James Bottomley wrote:
> 
> You might also try this patch from martin petersen:  it will print out
> the actual command that's causing the problems ... that might give a
> clue.
> 
> James

On the bugzilla entry ,

http://bugzilla.kernel.org/show_bug.cgi?id=13727

Thomas Meyer indicated it was (possibly) the following commit,

018e0446890661504783f92388ecce7138c1566d

I added Jens to the CC ..

Daniel

