Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935453Ab0BZHnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 02:43:05 -0500
Received: from mail.perches.com ([173.55.12.10]:1209 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935419Ab0BZHnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 02:43:03 -0500
Subject: Re: [PATCH 03/07] kernel.h string cleanup
From: Joe Perches <joe@perches.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <a8e1da1002252333g6e8bf94crba465c59c0cbc07a@mail.gmail.com>
References: <20100225155359.GA2722@darkstar> <20100225185515.GB3305@core2>
	 <a8e1da1002251714l55ccbd44ibc1119770667c62b@mail.gmail.com>
	 <b6fcc0a1002252315k1fd5360ehf5ea33566c19515d@mail.gmail.com>
	 <a8e1da1002252333g6e8bf94crba465c59c0cbc07a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 23:42:59 -0800
Message-ID: <1267170179.12041.4.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 15:33 +0800, Dave Young wrote:
> It will be better to move some of them to proper place instead of kernel.h

Perhaps you could describe some of the reasons why
it's better to move them.

Maybe you could post the results of a timed compile
comparison with kernel.h broken into multiple pieces
while you're at it.


