Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbZDFREj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbZDFREj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 13:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZDFRE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 13:04:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33008 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbZDFRE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 13:04:28 -0400
Message-ID: <49DA35EC.1000703@garzik.org>
Date: Mon, 06 Apr 2009 13:03:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@linux-foundation.org, jj@chaosbits.net,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Make CONFIG_SLOW_WORK an automatic rather than manual
 config	option
References: <20090406144725.19407.16817.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090406144725.19407.16817.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Make CONFIG_SLOW_WORK an automatic rather than manual config option so that
> people configuring their kernels don't have to make the choice.  It can be
> selected automatically by those things that require it (such as FS-Cache).
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>

thanks!

