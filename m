Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbXKARIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbXKARIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbXKARIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:08:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33405 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXKARIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:08:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [PATCH resend] proc: Fix proc_kill_inodes to kill dentries on all proc superblocks
References: <m1ir4mezzy.fsf@ebiederm.dsl.xmission.com>
	<4729F549.6090905@openvz.org> <20071101155938.GB16499@localhost.sw.ru>
Date: Thu, 01 Nov 2007 11:07:18 -0600
In-Reply-To: <20071101155938.GB16499@localhost.sw.ru> (Alexey Dobriyan's
	message of "Thu, 1 Nov 2007 18:59:38 +0300")
Message-ID: <m1hck5evy1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@sw.ru> writes:

> Yup, all this bogo-revoke is going away RSN. you just kicked my lazy ass.

As long as the issue is fixed I don't care.

Eric


