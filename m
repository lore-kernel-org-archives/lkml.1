Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYFJFVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYFJFVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 01:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYFJFVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 01:21:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbYFJFVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 01:21:44 -0400
Date: Mon, 9 Jun 2008 22:21:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bugfix: was Re: [ linus-git ] prctl(PR_SET_KEEPCAPS,
 ...) is broken for some configs, e.g. CONFIG_SECURITY_SELINUX
Message-Id: <20080609222114.7312650a.akpm@linux-foundation.org>
In-Reply-To: <484E0280.2050305@kernel.org>
References: <1212932321.4675.9.camel@earth>
	<484BF662.9070100@kernel.org>
	<20080608110630.08a45cc6.akpm@linux-foundation.org>
	<484C5E84.2020307@kernel.org>
	<20080608163926.56f1be3d.akpm@linux-foundation.org>
	<20080609171741.GA13403@us.ibm.com>
	<484E0280.2050305@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2008 21:26:40 -0700 "Andrew G. Morgan" <morgan@kernel.org> wrote:

> See: http://bugzilla.kernel.org/show_bug.cgi?id=10748

mutter.  Could we have a real changelog please?
