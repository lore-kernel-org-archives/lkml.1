Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbXC1Pj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbXC1Pj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 11:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932425AbXC1Pj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 11:39:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:32227 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbXC1Pjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 11:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=o4BJ+O646ULsUshKAZy6Bv6jyaTAw5j3VY+BoDILSCNSpVxjkmKm13w8H3aM2ht0jjkmS8clRBsMUWuQ+XY67jLTalABsg8YWSmyAWamKFyGJi1cgAsq9KXSaMe9Hpas19N0uacngFguQXQeGopyvyOHDiblcX9bHarRPIcasJ8=
Message-ID: <75b66ecd0703280839h12cfce34v39b04dfd254cc020@mail.gmail.com>
Date: Wed, 28 Mar 2007 11:39:53 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: oracle sqlplus loop on 2.6.20
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BAY103-DAV13FD7B01A80319110AFA3BB26D0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BAY103-DAV13FD7B01A80319110AFA3BB26D0@phx.gbl>
X-Google-Sender-Auth: bf5c9363f85931d5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/07, Marco Berizzi <pupilla@hotmail.com> wrote:
> Hello everybody.
> I'm running oracle 10.2.0.1 on Slackware Linux 10.2
> After 50 days uptime, sqlplus was looping forever.
> I have killed all oracle processes and cleared all
> semaphore and shared memory segment with ipcrm.
> I have also unmounted & remounted the file system
> where the oracle binaries and library resides,
> but no luck. I have to do a shutdown.
> This is the output from 'strace sqlplus'.
> Any hint?

Why do you think it's a kernel issue?  Sounds like an Oracle bug to me...

Lee
