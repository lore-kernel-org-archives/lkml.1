Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab0BEXZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 18:25:47 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:21077 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698Ab0BEXZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 18:25:45 -0500
Date: Fri, 5 Feb 2010 15:24:44 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>, tao.ma@oracle.com,
       ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ocfs2: Fix contiguousness check in
 ocfs2_try_to_merge_extent_map()
Message-ID: <20100205232443.GF3416@mail.oracle.com>
Mail-Followup-To: Roel Kluin <roel.kluin@gmail.com>,
	Mark Fasheh <mfasheh@suse.com>, tao.ma@oracle.com,
	ocfs2-devel@oss.oracle.com,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <4B6BE443.5000307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6BE443.5000307@gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B6CA8EB.017B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 10:26:27AM +0100, Roel Kluin wrote:
> The wrong member was compared in the continguousness check.
> 
> Acked-by: Tao Ma <tao.ma@oracle.com>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"Sometimes when reading Goethe I have the paralyzing suspicion
 that he is trying to be funny."
         - Guy Davenport

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
