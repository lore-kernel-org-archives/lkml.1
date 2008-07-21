Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYGULSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYGULSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYGULSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:18:42 -0400
Received: from namei.org ([69.55.235.186]:44415 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750719AbYGULSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:18:41 -0400
Date: Mon, 21 Jul 2008 21:17:45 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Eric Paris <eparis@redhat.com>
cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: request for comment: generic kernel interface for malware vendors
In-Reply-To: <1216613887.2960.18.camel@localhost.localdomain>
Message-ID: <Xine.LNX.4.64.0807212054001.17349@us.intercode.com.au>
References: <1216613887.2960.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008, Eric Paris wrote:

[ITYM anti-malware vendors...]

> First I'd like to thank Sophos who stepped up and originally wrote a lot
> of this code.  They might not recognize it since I've gotten my hands on
> it, but they were nice enough to get the ball rolling by giving me some
> GPL code which addressed near every request people on the malware list
> had.

We need a document explaining what the problem being solved actually is.  

What is the rationale for adding malware scanning to the Linux kernel?  
How does it benefit people?  Why does it need to be in the kernel?  What 
are the general requirements, and how does this interface meet those ?  
Does this interface represent an approach suitable to a range of 
anti-malware vendors ?

(I'm assuming the fundamental question of whether malware scanning is a 
good idea or not is not up for discussion, because there'll never be 
consensus).



- James
-- 
James Morris
<jmorris@namei.org>
