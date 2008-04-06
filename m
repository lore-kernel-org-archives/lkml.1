Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYDFUqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYDFUqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 16:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYDFUqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 16:46:33 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:56035 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751730AbYDFUqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 16:46:33 -0400
Date: Sun, 6 Apr 2008 16:46:26 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel serial reduce trasmitting window & code style
 patch
Message-ID: <20080406164626.13595588@siona.local>
In-Reply-To: <524838.25009.qm@web26206.mail.ukl.yahoo.com>
References: <524838.25009.qm@web26206.mail.ukl.yahoo.com>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 10:39:06 +0200 (CEST)
Michael Trimarchi <trimarchimichael@yahoo.it> wrote:

> Coding style clean-up patch.
> 
> Signed-off-by: michael <trimarchi@gandalf.sssup.it>

NAK. The existing style looks just fine to me.

If you want to line up the #defines, please just include that change in
the other patch. I'll comment on that in a few seconds.

Haavard
