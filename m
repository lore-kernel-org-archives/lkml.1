Return-Path: <linux-kernel-owner+w=401wt.eu-S1751866AbXAXO4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbXAXO4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 09:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbXAXO4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 09:56:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbXAXO4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 09:56:53 -0500
Message-ID: <45B773C1.7090805@redhat.com>
Date: Wed, 24 Jan 2007 09:57:05 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Stefan Priebe - FH <studium@profihost.com>
CC: linux-kernel@vger.kernel.org, stefan@priebe.ws,
       David Chinner <dgc@sgi.com>
Subject: Re: XFS or Kernel Problem / Bug
References: <20060801141545.B2326184@wobbly.melbourne.sgi.com> <44CED76B.20507@profihost.com> <20060801142755.C2326184@wobbly.melbourne.sgi.com> <44CED8F4.9080208@profihost.com> <20060801143212.D2326184@wobbly.melbourne.sgi.com> <44CEDA1D.5060607@profihost.com> <20060801143803.E2326184@wobbly.melbourne.sgi.com> <44CF36FB.6070606@profihost.com> <20060802090915.C2344877@wobbly.melbourne.sgi.com> <44D07AB7.3020409@profihost.com> <20060802201805.A2360409@wobbly.melbourne.sgi.com> <45B35CD7.4080801@profihost.com> <45B666BE.8000802@redhat.com> <45B70D69.20500@profihost.com>
In-Reply-To: <45B70D69.20500@profihost.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Priebe - FH wrote:
> Hi!
>
> I do everything you like :-) if we can find the bug.
>
> So here are the files (2.6.18.6):
> http://server055.de-nserver.de/filemap.o
> http://server055.de-nserver.de/filemap.s
>
>>
>> If you can, post the file mm/filemap.o from your build directory to some
>> website.
>> And do 'make mm/filemap.s' and post that file too.
>>
>
That doesn't match your oops at all.  Did you use a different compiler
and/or
different kernel build options?


