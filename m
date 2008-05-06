Return-Path: <linux-kernel-owner+w=401wt.eu-S1762413AbYEFXGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762413AbYEFXGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYEFXFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:05:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55743
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762251AbYEFXFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:05:13 -0400
Date: Tue, 06 May 2008 16:05:08 -0700 (PDT)
Message-Id: <20080506.160508.58694844.davem@davemloft.net>
To: rjw@sisk.pl
Cc: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: Soft lockup regression from today's sched.git merge.
From: David Miller <davem@davemloft.net>
In-Reply-To: <200805070041.02618.rjw@sisk.pl>
References: <20080422.030519.259068348.davem@davemloft.net>
	<1208868304.7115.251.camel@twins>
	<200805070041.02618.rjw@sisk.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 7 May 2008 00:41:01 +0200

> Can you please tell me what the current status of this is?

Group scheduling bug, fixed in Linus's tree already.
