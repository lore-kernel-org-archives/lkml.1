Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbXHWLxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbXHWLxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 07:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757730AbXHWLx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 07:53:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:6960 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344AbXHWLx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 07:53:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=c3nsr+3/jCLwecWbQyaK/+yZYp5OTWVFsleBixWDQe76NlFsP7R9QwbzHwwqMoH7YK/NkztSjdAKqzAFr98Bonk2wrbwG11CDpeQ3/9EqOCS7OSKw0rnVT0jaW5mrB+tKy8/v+8p4MsZRsPM//7dW1kP3YZEZwxldsHA7Jdaqbk=
Date: Thu, 23 Aug 2007 13:49:08 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Laurent CARON <lcaron@unix-scripts.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Server crashes unexpectedly
Message-ID: <20070823114908.GD31846@slug>
References: <46CD6C40.7070403@unix-scripts.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CD6C40.7070403@unix-scripts.info>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 01:15:12PM +0200, Laurent CARON wrote:
> Hi,
> 
> One of my server crashes randomly.
> 
> I suspect a filesystem corruption.
What makes you think so?  I'd check the memory with memtest.

Regards,
Frederik
