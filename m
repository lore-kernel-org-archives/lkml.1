Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbZCQTQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbZCQTQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 15:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZCQTQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 15:16:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55070
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbZCQTQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 15:16:05 -0400
Date: Tue, 17 Mar 2009 12:15:50 -0700 (PDT)
Message-Id: <20090317.121550.127196463.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crash with /proc/iomem on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0903170934080.7433@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0903170758060.24107@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0903170807440.25109@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0903170934080.7433@hs20-bc2-1.build.redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Tue, 17 Mar 2009 09:35:23 -0400 (EDT)

> Cc: stable@kernel.org
> 
> because it applies to old kernels as well, even 2.6.26 crashes.

-stable will be sent a copy by me when it hits Linus's tree, and no
sooner.
