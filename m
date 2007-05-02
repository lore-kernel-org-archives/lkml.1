Return-Path: <linux-kernel-owner+w=401wt.eu-S2993429AbXEBQKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993429AbXEBQKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993436AbXEBQKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:10:45 -0400
Received: from holomorphy.com ([66.93.40.71]:47977 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993429AbXEBQKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:10:44 -0400
Date: Wed, 2 May 2007 09:11:17 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christian Schmidt <lkml@digadd.de>, linux-kernel@vger.kernel.org
Subject: Re: Memory consumption on linux
Message-ID: <20070502161117.GW19966@holomorphy.com>
References: <4637958F.5010405@digadd.de> <p73odl3xvie.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73odl3xvie.fsf@bingen.suse.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Schmidt <lkml@digadd.de> writes:
>> Global cache is easy to understand - file system / inode caches. What
>> exactly is buffers, though?

On Wed, May 02, 2007 at 02:25:29PM +0200, Andi Kleen wrote:
> http://www.halobates.de/memorywaste.pdf and http://www.halobates.de/memory.pdf
> give some overview of in kernel memory users.

Very interesting. This is a veritable TODO list.


-- wli
