Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbXI1Fum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbXI1Fum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 01:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbXI1Fue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 01:50:34 -0400
Received: from mx10.go2.pl ([193.17.41.74]:58887 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755403AbXI1Fue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 01:50:34 -0400
Date: Fri, 28 Sep 2007 07:52:56 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nadia.Derbey@bull.net
Cc: akpm@linux-foundation.org, adobriyan@sw.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm1 0/2]  Fix unlocked call to idr_find()
Message-ID: <20070928055256.GA1767@ff.dom.local>
References: <20070927143354.663489000@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927143354.663489000@bull.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 04:33:54PM +0200, Nadia.Derbey@bull.net wrote:
> 
> This a series of 2 patches that should be applied on top of the other ipc
> patches, in 2.6.23-rc6-mm1.
...
> They should be applied to 2.6.23-rc6-mm1, in the following order:

Didn't you mean 2.6.23-rc8-mm1, btw?

Regards,
Jarek P.
