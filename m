Return-Path: <linux-kernel-owner+w=401wt.eu-S1751113AbXBZFw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113AbXBZFw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 00:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXBZFw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 00:52:26 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33190 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbXBZFwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 00:52:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MSI entry unlinked before arch_teardown_msi_irq().
References: <m17iu6r4eg.fsf@ebiederm.dsl.xmission.com>
	<20070225.154637.70478886.davem@davemloft.net>
	<m18xelpyfg.fsf@ebiederm.dsl.xmission.com>
	<20070225.180303.78711157.davem@davemloft.net>
Date: Sun, 25 Feb 2007 22:51:59 -0700
In-Reply-To: <20070225.180303.78711157.davem@davemloft.net> (David Miller's
	message of "Sun, 25 Feb 2007 18:03:03 -0800 (PST)")
Message-ID: <m1y7mlo48w.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> Nevermind, something strange is going on here.  I think my
> patch is bogus and the thing is still crashing, let me get
> back to you.

Sure.  

Eric
