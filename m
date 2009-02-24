Return-Path: <linux-kernel-owner+w=401wt.eu-S1761153AbZBXWjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761153AbZBXWjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759113AbZBXWjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:39:09 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:50533 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbZBXWjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:39:06 -0500
Date: Tue, 24 Feb 2009 16:39:03 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org, akpm@linux-foundation.org,
       Nadia.Derbey@bull.net, adobriyan@gmail.com, clg@fr.ibm.com
Subject: Re: + namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
	added to -mm tree
Message-ID: <20090224223903.GC31959@us.ibm.com>
References: <200902242217.n1OMHanG015751@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902242217.n1OMHanG015751@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting akpm@linux-foundation.org (akpm@linux-foundation.org):
> 
> The patch titled
>      mqueue-namespace-adapt-sysctl-update-fix
> has been added to the -mm tree.  Its filename is
>      namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: mqueue-namespace-adapt-sysctl-update-fix
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Cc: "Serge E. Hallyn" <serue@us.ibm.com>

Ok, it'll certainly work and is in line with other users, *and*
is apparently deemed nicer by everyone, so

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge
