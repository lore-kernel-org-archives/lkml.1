Return-Path: <linux-kernel-owner+w=401wt.eu-S933492AbYCFCL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbYCFCL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764816AbYCFCL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:11:29 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:40188 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805AbYCFCL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:11:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HgAwINU2Y7gNYkn3UV64UKrR72SVns2ehV0JNCEHxBxRw2tnCsRcnrauJ+KUVdLFONnymr03YAQXa2EQ5YroifC+hW5Nvl7/YQlxJsm5mmYQOfIWXqRhKoQZyPLLk9SGrzaJKI8n179V8pX5jzDOl5S2X2EBZcNgzGlz1icXuYs=
Message-ID: <df9815e70803051811o4c4a42e0td56cfd32b80c66b2@mail.gmail.com>
Date: Thu, 6 Mar 2008 10:11:26 +0800
From: "Jike Song" <albcamus@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: 2.6.25-rc4 rcupreempt.h WARNINGs while suspend/resume
Cc: "Dave Young" <hidave.darkstar@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080305165531.GB8728@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0803042324ndd3873ay61cee6112d9dda9a@mail.gmail.com>
	 <df9815e70803042335j4ea66028y96d6be21f0970aa1@mail.gmail.com>
	 <20080305165531.GB8728@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2008 at 12:55 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>  Could you please try applying Karsten Wiese's patch to see if it
>  fixes the WARNINGs?  See http://lkml.org/lkml/2008/2/26/386 for
>  the patch.
>
>                                                 Thanx, Paul

Yes, the WARNING disappears with Karsten's patch applied.
Thanks.
