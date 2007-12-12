Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbXLLTMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbXLLTMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755632AbXLLTL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:11:56 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:45604 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbXLLTLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:11:54 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
CC: "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
Date: Wed, 12 Dec 2007 19:08:09 +0000
Subject: RE: [PATCH 21/30] blk_end_request: changing cciss (take 4)
Thread-Topic: [PATCH 21/30] blk_end_request: changing cciss (take 4)
Thread-Index: Acg85FbQTKQkjiDoQlyZ5XWTLglTkgADcbDQ
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE15718F19@G6W0268.americas.hpqcorp.net>
References: <20071211.175003.10249786.k-ueda@ct.jp.nec.com>
	<DEE40752C8AF224BB890E455C7B8E0FE15718B35@G6W0268.americas.hpqcorp.net>
 <20071212.122752.104028559.k-ueda@ct.jp.nec.com>
In-Reply-To: <20071212.122752.104028559.k-ueda@ct.jp.nec.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > Why is this removed?
>
> Sorry for the less explanation.
>
> Because it is done in __end_that_request_first() called from
> blk_end_request().
> I'll add the explanation to the patch description when I
> update the patch.
>

Thank you. I've Acked the patch.

-- mikem
