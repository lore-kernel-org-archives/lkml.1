Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYCJOp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYCJOp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 10:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYCJOpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 10:45:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbYCJOpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 10:45:45 -0400
Date: Mon, 10 Mar 2008 07:45:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: charles gagalac <charles.gagalac@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc5
In-Reply-To: <6cf66ee10803092305r64536f26u18b8239b04a88af2@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0803100744160.5896@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803092231580.5896@woody.linux-foundation.org> <6cf66ee10803092305r64536f26u18b8239b04a88af2@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 9 Mar 2008, charles gagalac wrote:
>
> i see the -rc5 patches are uploaded, but the git tree isn't updated.

Duh. Thanks for pointing that out. It's uptodate now (it wasn't really far 
off before either - just the tag and one really trivial patch to remove a 
duplicate header include)

		Linus
