Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbZACNuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbZACNuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 08:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758403AbZACNuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 08:50:07 -0500
Received: from 1wt.eu ([62.212.114.60]:1077 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423AbZACNuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 08:50:06 -0500
Date: Sat, 3 Jan 2009 14:45:58 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: davej@redhat.com, jschopp@austin.ibm.com, apw@uk.ibm.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: scripts/checkpatch.pl in 2.4 git
Message-ID: <20090103134558.GA21058@1wt.eu>
References: <3f9a31f40901030534v268d315ep4f1241042fafc456@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901030534v268d315ep4f1241042fafc456@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 07:04:57PM +0530, Jaswinder Singh Rajput wrote:
> Hello Willy,
> 
> Do you have any plans to add scripts/checkpatch.pl in 2.4 git.

Not particularly planned, though I have nothing against including it if
some people want to use it.

> Currently, what is the procedure to check patch for 2.4 git.

Nowadays, 2.4 patches are so small that one's eyes are enough to check
for correctness ;-)

And sometimes if the patch is not correct, I do fix it myself while merging it.

Regards,
Willy

