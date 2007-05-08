Return-Path: <linux-kernel-owner+w=401wt.eu-S966792AbXEHB0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966792AbXEHB0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 21:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966697AbXEHB0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 21:26:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53009 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966580AbXEHB0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 21:26:02 -0400
Message-ID: <463FD1A2.1020505@garzik.org>
Date: Mon, 07 May 2007 21:25:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
       cmm@us.ibm.com
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
References: <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426181332.GD7209@amitarora.in.ibm.com> <20070503213133.d1559f52.akpm@linux-foundation.org> <20070507113753.GA5439@schatzie.adilger.int> <20070507135825.f8545a65.akpm@linux-foundation.org> <20070507222103.GJ8181@schatzie.adilger.int> <463FB008.3080706@garzik.org> <20070508010736.GO8181@schatzie.adilger.int>
In-Reply-To: <20070508010736.GO8181@schatzie.adilger.int>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> My comment was just that the extent doesn't have to be explicitly zero
> filled on the disk, by virtue of the fact that the uninitialized flag
> will cause reads to return zero.


Agreed, thanks for the clarification.

	Jeff


