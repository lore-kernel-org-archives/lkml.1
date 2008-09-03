Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbYICGYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbYICGYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 02:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYICGYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 02:24:45 -0400
Received: from smtp.nokia.com ([192.100.105.134]:34695 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbYICGYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 02:24:44 -0400
Subject: Re: [PATCH] UBIFS: fill f_fsid
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger@sun.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
In-Reply-To: <1220390769.2985.6.camel@pmac.infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
	 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
	 <1220262187.2982.58.camel@pmac.infradead.org>
	 <20080901150147.GA20323@infradead.org> <1220339032.4036.31.camel@sauron>
	 <20080902170954.GE3086@webber.adilger.int>
	 <20080902210219.GA9856@infradead.org>
	 <1220390769.2985.6.camel@pmac.infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 03 Sep 2008 09:20:30 +0300
Message-Id: <1220422830.4036.38.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 03 Sep 2008 06:23:59.0749 (UTC) FILETIME=[A6D7F350:01C90D8D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 22:26 +0100, David Woodhouse wrote:
> That was Artem's motivation for filling in f_fsid in the first place.

Yes, right. I am planning NFS support and would like to have UBIFS
filling f_fsid.

> Does anything else even _care_ about f_fsid? 

I do not know anything but NFS.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

