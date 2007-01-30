Return-Path: <linux-kernel-owner+w=401wt.eu-S965620AbXA3QyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620AbXA3QyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965630AbXA3QyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:54:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:30501 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965620AbXA3QyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:54:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lxIhWfZyLuidvOSVXk8VM4VYTS0qPEtfgN2AP+5cuEqGGuzGSAcXmZObUvCinKHJirgJV84Gt4+oMlitl3f/739pOIxNyWk8ObzNO0O7tFJJ7GQLBslxvX8Jv3Va9KR3JLL8WCq5CJt15ybqU8StQ/f7wugXR6d6qj8EjpwMG/Y=
Message-ID: <671c20540701300854o4cc0da13s797290c066d1b96b@mail.gmail.com>
Date: Tue, 30 Jan 2007 11:54:19 -0500
From: "Tom Burns" <tom.i.burns@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Bug: 2.6.15 Process accounting fails to account for small time slice loads (still)
In-Reply-To: <671c20540701300824p54dad7dbw43fe916bc8c98d45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <671c20540701300824p54dad7dbw43fe916bc8c98d45@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Problem also verified to exist on kernel:
2.6.17-5mdv #1 SMP Wed Sep 13 14:28:02 EDT 2006 x86_64 Intel(R)
Core(TM)2 CPU          6400  @ 2.13GHz GNU/Linux

Cheers,
Tom Burns

On 1/30/07, Tom Burns <tom.i.burns@gmail.com> wrote:
> The bug described back in 2004 in the following message still seems to exist:
>
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-05/4313.html
>
> .. snipped..
