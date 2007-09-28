Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbXI1OpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbXI1OpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbXI1OpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:45:12 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:59467 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbXI1OpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:45:10 -0400
Message-ID: <46FD1372.70608@tiscali.nl>
Date: Fri, 28 Sep 2007 16:45:06 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use array_size macro
References: <46FCDBE9.8030406@tiscali.nl> <46FCDDDF.8020500@tiscali.nl> <20070928131514.GA5209@c2.user-mode-linux.org>
In-Reply-To: <20070928131514.GA5209@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Fri, Sep 28, 2007 at 12:56:31PM +0200, Roel Kluin wrote:
>> arch/um/kernel/tt/ptproxy/ptrace.c      |   12 ++++++------
> 
> I don't know what you're diffing against, but this file is history in
>  -mm, and will be gone in mainline after 2.6.23.
> 
> Jeff
> 
Thanks for noting me. I usually pull the masters branch, so my previously submitted
patches are against that. Apparently I have to apply the -mm patchset before sending
patches. Is there a git branch to pull from for that?

Roel
