Return-Path: <linux-kernel-owner+w=401wt.eu-S1759657AbZCPN1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbZCPN1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZCPN1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:27:33 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:34088 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbZCPN1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:27:32 -0400
Subject: Re: [PATCH 4/7] writeback: get rid of task/current_is_pdflush()
From: Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, david@fromorbit.com, npiggin@suse.de
In-Reply-To: <20090316101425.GB21118@infradead.org>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com>
	 <1236868428-20408-5-git-send-email-jens.axboe@oracle.com>
	 <20090316101425.GB21118@infradead.org>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 09:26:30 -0400
Message-Id: <1237209990.30224.0.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.49BE538A.009E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 06:14 -0400, Christoph Hellwig wrote:
> On Thu, Mar 12, 2009 at 03:33:45PM +0100, Jens Axboe wrote:
> > There's just a single user in the kernel and Chris says it's safe to kill.
> 
> I'll defer about the use to Chris, but if this can go it should now,
> not deep inside the series.
> 

I'll queue it up for 2.6.30-rc1

-chris


