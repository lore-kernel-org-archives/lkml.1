Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab0BTPb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 10:31:27 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:35424 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab0BTPbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 10:31:25 -0500
Subject: Re: sysfs lockdep complaint
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <1266679687.17363.1.camel@jlt3.sipsolutions.net>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com>
	 <1266664814.11514.5.camel@jlt3.sipsolutions.net>
	 <20100220135122.GB3000@hack>
	 <1266674493.18465.9.camel@jlt3.sipsolutions.net>
	 <20100220150327.GG3000@hack>
	 <1266678496.32309.1.camel@jlt3.sipsolutions.net>
	 <20100220152010.GI3000@hack>
	 <1266679687.17363.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 16:31:23 +0100
Message-ID: <1266679883.17363.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 16:28 +0100, Johannes Berg wrote:

> I have this now, and that removed all the warnings:

But I still don't get anything back wrt. the original problem ... still
hangs after printing "disabling non-boot CPUs"

:(

johannes

