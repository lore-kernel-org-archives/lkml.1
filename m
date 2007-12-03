Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbXLCBer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbXLCBer (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 20:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbXLCBei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 20:34:38 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44011 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXLCBeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 20:34:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Greg KH" <gregkh@suse.de>, "rae l" <crquan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Since sysfs_mount is static and used only in sysfs_init function, it could be just an automatic variable.
References: <91b13c310712011231k3604214bx3559387c568cce09@mail.gmail.com>
	<20071202044825.GA7004@suse.de>
	<91b13c310712012252k5307735x782582fd2d7abd94@mail.gmail.com>
	<20071202075437.GA19897@suse.de>
	<m14pf03fex.fsf@ebiederm.dsl.xmission.com>
	<20071202225320.GA23359@suse.de>
	<3ae72650712021646r8376bb9s73e326db5789839d@mail.gmail.com>
Date: Sun, 02 Dec 2007 18:33:24 -0700
In-Reply-To: <3ae72650712021646r8376bb9s73e326db5789839d@mail.gmail.com> (Kay
	Sievers's message of "Mon, 3 Dec 2007 01:46:57 +0100")
Message-ID: <m1wsrw1s0r.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kay Sievers" <kay.sievers@vrfy.org> writes:

> That cruft is going away with the block patch in your tree.

And it doesn't matter because it is a separate mount anyway.
Although I have to admit I hadn't taken that mount into
account earlier.

Eric

