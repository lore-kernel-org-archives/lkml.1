Return-Path: <linux-kernel-owner+w=401wt.eu-S933776AbZJNULU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776AbZJNULU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933724AbZJNULU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:11:20 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45370 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933699AbZJNULT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:11:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=yziJ3EIgSz8XcYNQPgHmhgBWZ3GbE6w6zuqHC5xyyiFy1d3j/+OcnMfXwwmqCDWuy
	Ku4gaIIJMRl1RS2hyCcbg==
Date: Wed, 14 Oct 2009 13:09:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jonathan Corbet <corbet@lwn.net>
cc: LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [PATCH] update flex_array document
In-Reply-To: <20091014125542.53dfe602@bike.lwn.net>
Message-ID: <alpine.DEB.1.00.0910141309430.21854@chino.kir.corp.google.com>
References: <20091014125542.53dfe602@bike.lwn.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Jonathan Corbet wrote:

> I promised I would update this document for the 2.6.32 changes.
> Amazingly enough, I actually did it; results below.  If nobody objects,
> I'll send this upward shortly.
> 
> jon
> ---
> Update flex_arrays.txt
> 
> The 2.6.32 merge window brought a number of changes to the flexible array
> API; this patch updates the documentation to match the new state of
> affairs.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

Acked-by: David Rientjes <rientjes@google.com>

Thanks Jonathan!
