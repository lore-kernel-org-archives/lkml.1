Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbZKCFri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbZKCFri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 00:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZKCFrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 00:47:37 -0500
Received: from smtp.nokia.com ([192.100.105.134]:44150 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZKCFrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 00:47:36 -0500
Subject: Re: [PATCH 26/27] BKL: Remove BKL from ubifs
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       linux-mtd@lists.infradead.org, Al Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       Adrian Hunter <adrian.hunter@nokia.com>
In-Reply-To: <1257156307-24175-27-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
	 <1257156307-24175-27-git-send-email-jblunck@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Nov 2009 07:47:02 +0200
Message-Id: <1257227222.21596.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Nov 2009 05:47:07.0947 (UTC) FILETIME=[147B3FB0:01CA5C49]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 11:05 +0100, Jan Blunck wrote:
> BKL is only used in get_sb. It is safe to remove it.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
 
-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

