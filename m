Return-Path: <linux-kernel-owner+w=401wt.eu-S933297AbYCFDVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297AbYCFDVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 22:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbYCFDUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 22:20:54 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:45011 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbYCFDUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 22:20:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QLsSdyvnuzYE4JU/1CxHs5qmFeekaphqCkJJIjketxZvZv0SeFbG9yfVSvJJCmy/+/Hbih46iDAJBc3tIuM5KJXLlwdbWFOm1+d22ZYwXhMty4smrYb7A5nA2yb0h+S/GPkhPKzI84ChqUZS6wC1+VS/OOByYOMqVb+unm4sgrM=
Message-ID: <a8e1da0803051920t586c7fbapadda70ae895f8893@mail.gmail.com>
Date: Thu, 6 Mar 2008 11:20:49 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: 2.6.25-rc4 rcupreempt.h WARNINGs while suspend/resume
Cc: "Jike Song" <albcamus@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080306022854.GK8728@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0803042324ndd3873ay61cee6112d9dda9a@mail.gmail.com>
	 <df9815e70803042335j4ea66028y96d6be21f0970aa1@mail.gmail.com>
	 <20080305165531.GB8728@linux.vnet.ibm.com>
	 <df9815e70803051811o4c4a42e0td56cfd32b80c66b2@mail.gmail.com>
	 <20080306022854.GK8728@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2008 at 10:28 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> On Thu, Mar 06, 2008 at 10:11:26AM +0800, Jike Song wrote:
>  > On Thu, Mar 6, 2008 at 12:55 AM, Paul E. McKenney
>  > <paulmck@linux.vnet.ibm.com> wrote:
>  > >  Could you please try applying Karsten Wiese's patch to see if it
>  > >  fixes the WARNINGs?  See http://lkml.org/lkml/2008/2/26/386 for
>  > >  the patch.
>  > >
>  > >                                                 Thanx, Paul
>  >
>  > Yes, the WARNING disappears with Karsten's patch applied.
>  > Thanks.

Confirmed

>
>  Good to hear!!!  I believe that Karsten's patch is on its way in,
>  so hopefully that will clear things up.
>
>                                                 Thanx, Paul
>
