Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYIKXsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYIKXsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 19:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYIKXsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 19:48:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60887
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbYIKXsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 19:48:00 -0400
Date: Thu, 11 Sep 2008 16:47:54 -0700 (PDT)
Message-Id: <20080911.164754.205344391.davem@davemloft.net>
To: elad_lahav@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Initial support for Niagara T1 performance counters
From: David Miller <davem@davemloft.net>
In-Reply-To: <48C9AB16.3060706@users.sourceforge.net>
References: <48C98820.3080009@users.sourceforge.net>
	<20080911.145937.178601244.davem@davemloft.net>
	<48C9AB16.3060706@users.sourceforge.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Elad Lahav <elad_lahav@users.sourceforge.net>
Date: Thu, 11 Sep 2008 19:34:46 -0400

> Just for the record, is the implementation correct? Specifically, is
> this the right way to extract the PIL at the time of the trap?

Yep it looks right.

Also, for the record, you should post sparc patches at least
CC:'d to sparclinux@vger.kernel.org in the future.

