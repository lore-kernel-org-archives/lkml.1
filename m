Return-Path: <linux-kernel-owner+w=401wt.eu-S1766003AbYEUIef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766003AbYEUIef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683AbYEUIeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:34:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56769 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbYEUIeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:34:14 -0400
Date: Wed, 21 May 2008 09:34:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net
Subject: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard
	indentation of arguments)
Message-ID: <20080521083413.GM28946@ZenIV.linux.org.uk>
References: <12113495282137-git-send-email-kongjianjun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12113495282137-git-send-email-kongjianjun@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a call for discussion for new maillist on vger.

List name: linux-wanking@vger.kernel.org

Rationale: the need for such list has been demonstrated during the last few
months by rapid increase in the amount of traffic topical for such list
(and completely unrelated to any kind of kernel development) misposted on
linux-kernel.  A separate list dedicated to this kind of self-gratification
would hopefully
	* reduce the gag reflex among the l-k readers
	* provide a forum where such activity could be indulged in comfort
and safety from mocking
	* in cases inspiring Ingo's theory of spontaneous onset of sanity,
shield the emerging sentients from the prejudice created by their previous
output.

Exhibit A:

On Wed, May 21, 2008 at 01:58:48PM +0800, Jianjun Kong wrote:
> Standard indentation of arguments.
> I use right blank space to displace the last table, in order to make the arguments alining. For example:
> 
> old:
> extern void test_fun(struct list_head *new,
> 			struct list_head *prev,
> 			struct list_head *next);
> new:
> extern void test_fun(struct list_head *new,
> 		     struct list_head *prev,
> 		     struct list_head *next);

Further examples can be trivially found in l-k archives and will be provided
on demand.
