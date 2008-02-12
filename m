Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbYBLUuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbYBLUuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYBLUtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:49:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47935
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752876AbYBLUtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:49:50 -0500
Date: Tue, 12 Feb 2008 12:50:22 -0800 (PST)
Message-Id: <20080212.125022.138926116.davem@davemloft.net>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
From: David Miller <davem@davemloft.net>
In-Reply-To: <200802120849.34477.chris.mason@oracle.com>
References: <20080211.232139.14959431.davem@davemloft.net>
	<20080212.001104.172517283.davem@davemloft.net>
	<200802120849.34477.chris.mason@oracle.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Mason <chris.mason@oracle.com>
Date: Tue, 12 Feb 2008 08:49:34 -0500

> So, if Btrfs starts zeroing at 1k, will that be acceptable for you?

Sure.
