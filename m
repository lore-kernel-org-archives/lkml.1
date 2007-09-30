Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbXI3Qpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbXI3Qpg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 12:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbXI3Qp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 12:45:28 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:26118 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXI3Qp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 12:45:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AXVdEhmwG3KevpFkr8s5Fg1lY0UueBSEs3hNFGyAQ48hnR1imejZkeThtg2C62f4YJizXmrjGy9zQISqh66228zsWjtzrpNh/OTC/QmNOYqHTZQqEROMGEnKDCdjbZEcTHLVqRQVUimXnpFUFzNyoFHY/KoHGD239+0r3ukgLQk=
Message-ID: <e85b9d30709300945h131bed02ja009f7b7d05dd4de@mail.gmail.com>
Date: Sun, 30 Sep 2007 18:45:26 +0200
From: Matthew <jackdachef@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8, v2.6.22.8, v2.6.21.7, v2.6.20.20
In-Reply-To: <e85b9d30709300943rded9801xddc6ca0a4773ff53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30709290411u4f48d716o3260bab7d71261ff@mail.gmail.com>
	 <20070930154354.GD24077@elte.hu>
	 <e85b9d30709300943rded9801xddc6ca0a4773ff53@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your answer (sorry, I didn't know your email had changed)

well, this will take some time since I don't work every day & it's
turned off most of the time, hope that is OK

before I proceed with that data-collection:

do you think it is possible that it might be related to "Fair group
CPU scheduler" being selected ?

I think that one and another additional option (don't know right now
its name, but will look for it later) was the only difference on the
.config-file between 2.6.23-rc8 & 2.6.23-rc8-git3 (+ sched-devel)

Mat
