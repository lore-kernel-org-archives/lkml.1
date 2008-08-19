Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbYHSE3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbYHSE3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 00:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYHSE3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 00:29:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37064
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbYHSE3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:29:32 -0400
Date: Mon, 18 Aug 2008 21:29:31 -0700 (PDT)
Message-Id: <20080818.212931.07033257.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-08-18
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080819142739.aee40461.sfr@canb.auug.org.au>
References: <20080818151551.GA5524@tuxdriver.com>
	<20080818.211632.251536898.davem@davemloft.net>
	<20080819142739.aee40461.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 19 Aug 2008 14:27:39 +1000

> Just as an extra datapoint, this has already merged into linux-next and
> built fine for a powerpc ppc64_defconfig and x86_64 allmodconfig this
> morning.  And yesterday's linux-next had the previous version of these
> patches (only commit comment differences as far as I am aware) and the
> build logs are at http://kisskb.ellerman.id.au/linux-next .

Thanks Stephen, they just passed my sparc64 allmodconfig builds
too :-)
