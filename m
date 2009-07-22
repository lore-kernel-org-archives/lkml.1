Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbZGVOqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbZGVOqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZGVOqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:46:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52299 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbZGVOqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:46:22 -0400
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: GFS2: Add LED support to GFS2
From: Andi Kleen <andi@firstfloor.org>
References: <1248260198.3456.4.camel@localhost.localdomain>
Date: Wed, 22 Jul 2009 16:46:18 +0200
In-Reply-To: <1248260198.3456.4.camel@localhost.localdomain> (Steven Whitehouse's message of "Wed, 22 Jul 2009 11:56:38 +0100")
Message-ID: <87k5203hdx.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Whitehouse <swhiteho@redhat.com> writes:
>
> One possible future development is to introduce an event for
> filesystem errors, but that is not included in the current
> patch.

I like the idea, but it would be nicer if this was a generic
interface into which all file systems can hook into.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
