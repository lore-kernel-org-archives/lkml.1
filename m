Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbYDVWMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbYDVWMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbYDVWMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:12:39 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:39271 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757699AbYDVWMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:12:38 -0400
Date: Tue, 22 Apr 2008 15:12:37 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] scsi/qla2xxx/qla_os.c: make 2 functions static
Message-ID: <20080422221237.GA80148@d8550avq18955.qlogic.org>
References: <20080421084942.GV26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421084942.GV26897@cs181133002.pp.htv.fi>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 22 Apr 2008 22:12:37.0578 (UTC) FILETIME=[F928EAA0:01C8A4C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008, Adrian Bunk wrote:

> This patch makes the following needlessly global functions static:
> - qla2x00_alloc_work()
> - qla2x00_post_work()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks Adrian.  I'll add the two patches to my queue of qla2xxx
updates and submit the group shortly.

--
av
