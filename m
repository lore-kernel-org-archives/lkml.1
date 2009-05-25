Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbZEYLom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbZEYLom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbZEYLoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:44:32 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:43178 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbZEYLoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:44:30 -0400
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Neil Brown <neilb@suse.de>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       raz ben yehuda <raziebe@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: linux-next: md tree build failure
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20090525153346.758483fc.sfr@canb.auug.org.au>
	<20090525061552.GH11363@kernel.dk>
Date: Mon, 25 May 2009 07:44:14 -0400
In-Reply-To: <20090525061552.GH11363@kernel.dk> (Jens Axboe's message of "Mon,
	25 May 2009 08:15:52 +0200")
Message-ID: <yq17i05flv5.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4A1A8490.01D3:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

Jens> Martin, this is starting to look like a disaster :-(

Yeah.  I guess you should have pushed the accessors first and let that
patch steep for a while before applying the rest of the kit :|

It's just super bad timing that both Neil and Alasdair had patches to
their respective hardsect size areas right now.  Neither tree has been
touched in that department for ages...

*sigh*

-- 
Martin K. Petersen	Oracle Linux Engineering
