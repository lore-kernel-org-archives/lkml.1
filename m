Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbYH3QhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbYH3QhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 12:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYH3QhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 12:37:04 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:58040 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbYH3QhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 12:37:03 -0400
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Tejun Heo <tj@kernel.org>
Cc: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [fuse-devel] [PATCHSET] CUSE: implement CUSE
References: <1219947544-666-1-git-send-email-tj@kernel.org>
Date: Sat, 30 Aug 2008 18:35:53 +0200
In-Reply-To: <1219947544-666-1-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Fri, 29 Aug 2008 03:18:59 +0900")
Message-ID: <87ej465ul2.fsf@frosties.localdomain>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX18D3TMqHBRK/LR3dzpYvMnzmtQ+j6HdCGiLy4m+
	Wvu8BqTIhYH5d15i1ofvTFYQwdfZfuEqDauMkLae028rsciJ1S
	wy3VCCQEk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> This patchset implements CUSE - Character device in Userspace.  Except
> for initialization sequence and creation of character device instead
> of a mount, CUSE isn't very different from FUSE.

Would it be hard to extend this to block devices as well?

MfG
        Goswin
