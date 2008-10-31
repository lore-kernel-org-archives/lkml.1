Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYJaQ2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYJaQ2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYJaQ15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:27:57 -0400
Received: from rcsinet14.oracle.com ([148.87.113.126]:30244 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYJaQ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:27:56 -0400
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       device-mapper development <dm-devel@redhat.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] Add gfp_mask to bio_integrity_clone()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <490942D4.3070504@ce.jp.nec.com>
	<yq1hc6s3l4g.fsf@sermon.lab.mkp.net>
	<20081031141701.GI31673@kernel.dk>
Date: Fri, 31 Oct 2008 12:25:15 -0400
In-Reply-To: <20081031141701.GI31673@kernel.dk> (Jens Axboe's message of "Fri\, 31 Oct 2008 15\:17\:02 +0100")
Message-ID: <yq163n83f6c.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.490B3170.00AC:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

Jens> Shall I just include this in the 2.6.29 branch?

Sure!

-- 
Martin K. Petersen	Oracle Linux Engineering
