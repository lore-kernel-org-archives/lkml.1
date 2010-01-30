Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361Ab0A3TKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab0A3TKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178Ab0A3TKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:10:43 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:56855 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab0A3TKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:10:42 -0500
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] block: fix bugs in bio-integrity mempool usage
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <201001290102.o0T12nHu022353@int-mx05.intmail.prod.int.phx2.redhat.com>
Date: Sat, 30 Jan 2010 14:09:52 -0500
In-Reply-To: <201001290102.o0T12nHu022353@int-mx05.intmail.prod.int.phx2.redhat.com>
	(Chuck Ebbert's message of "Thu, 28 Jan 2010 20:02:48 -0500")
Message-ID: <yq1d40r5rzz.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B648421.0077:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


block: fix bugs in bio-integrity mempool usage

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
