Return-Path: <linux-kernel-owner+w=401wt.eu-S968294AbXILMn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968294AbXILMn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 08:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966516AbXILMnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 08:43:49 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:33217 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966469AbXILMns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 08:43:48 -0400
Message-ID: <46E7DEF8.50201@davidnewall.com>
Date: Wed, 12 Sep 2007 22:13:36 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stripping down the kernel-parameters.txt file
References: <Pine.LNX.4.64.0709120339470.26177@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0709120339470.26177@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   while killing some time between compiles and ridding the
> kernel-parameters.txt file of out-of-date or incorrect cruft, it
> occurs to me that that file is borderline valueless since it
> apparently tries to document every possible boot-time parameter,
> including those associated with individual modules.  that's just
> silly.
>   

"Silly" is such a negative word.  I think it's aspirational.  It 
probably can't be achieved, but that's no reason to give up, nor to 
remove existing text.

>   i suggest that that file record only the basic boot-time params, and
> the documentation for module-specific parameters be moved closer to
> the module source itself.  there's no point in that poor file trying
> to keep up with all of the module development in the tree.

Better yet, would be if module maintainers updated the file as they 
update their modules.
