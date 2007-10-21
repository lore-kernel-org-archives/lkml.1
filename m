Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbXJUTwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbXJUTwg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 15:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbXJUTw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 15:52:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56001
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbXJUTw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 15:52:28 -0400
Date: Sun, 21 Oct 2007 12:52:40 -0700 (PDT)
Message-Id: <20071021.125240.23398793.davem@davemloft.net>
To: cebbert@redhat.com
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [2.6.23] tasks stuck in running state?
From: David Miller <davem@davemloft.net>
In-Reply-To: <471B7752.7050306@redhat.com>
References: <47192D20.8090608@redhat.com>
	<20071019.170140.45897518.davem@davemloft.net>
	<471B7752.7050306@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>
Date: Sun, 21 Oct 2007 11:59:14 -0400

> IIRC -mm had something like this but it was buggy because we were
> sending IPIs to each processor asking them to print their state.

What's buggy about this? :-)  That's exactly how it work(ed)
on sparc64.

