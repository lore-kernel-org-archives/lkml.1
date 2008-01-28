Return-Path: <linux-kernel-owner+w=401wt.eu-S1761658AbYA1Vq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbYA1Vq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYA1Vqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:46:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036AbYA1Vqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:46:46 -0500
Date: Tue, 29 Jan 2008 08:46:37 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@www.l.google.com
To: Paul Mundt <lethal@linux-sh.org>
cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] sh updates for 2.6.25-rc1
In-Reply-To: <20080128095919.GA8546@linux-sh.org>
Message-ID: <alpine.LFD.1.00.0801290841030.3505@www.l.google.com>
References: <20080128095919.GA8546@linux-sh.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Jan 2008, Paul Mundt wrote:
>
>  484 files changed, 31831 insertions(+), 37139 deletions(-)

Please use "git diff -M --stat --summary" to generate the diffstat: the -M 
enables rename detection, and the summary enables a summary of new/deleted 
or renamed files.

With rename detection, the statistics are rather different:

 419 files changed, 13022 insertions(+), 18878 deletions(-)

because git will notice that a fair number of the changes are renames.

			Linus
