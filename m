Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZLAX2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZLAX2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 18:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbZLAX2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 18:28:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59820
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754557AbZLAX2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 18:28:38 -0500
Date: Tue, 01 Dec 2009 15:28:43 -0800 (PST)
Message-Id: <20091201.152843.207086860.davem@davemloft.net>
To: william.allen.simpson@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: warning: massive change to conditional coding style in net?
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B1558D8.4010804@gmail.com>
References: <4B13A025.7000103@gmail.com>
	<20091130.123644.203668577.davem@davemloft.net>
	<4B1558D8.4010804@gmail.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Allen Simpson <william.allen.simpson@gmail.com>
Date: Tue, 01 Dec 2009 12:56:40 -0500

> Heck, changes to comments!

Comments help people understand your code.  Long after you're gone and
no longer around, other people will need to read your code, maintain
it, and fix bugs in it.

That's why well written and properly formatted comments are important.

Again, nobody is picking on your specifically, everyone goes through
this review process.  What is unique about you is that you're the only
one who throws rotten tomatoes back at the reviewers instead of simply
fixing up your patch set and resubmitting.

If the changes requested are so simple and trivial, then it should
take you but a few minutes to respin your patches with the fixes
included.

It definitely takes you more effort to write all of these angry
emails, but how you spend your time is your choice.
