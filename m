Return-Path: <linux-kernel-owner+w=401wt.eu-S2992696AbXDYL2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992696AbXDYL2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992713AbXDYL2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:28:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:54816 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992698AbXDYL2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FXyxFiKwIqo6ZLXQNjAKmVQL8BYKv7azHRA2L8wL6CQiwIqswWghL8emzyZ7Qh7q5BF+dG8h/5LaSLWMRdGKA+oO5f4+1BQq60uX6oIt/1CGuVS0OYx1A9svBgbAexYCS9sLuFPIRJ9Ek9KOI1Tlo3+08QYPNjYsoTM+4BvEcR0=
Message-ID: <2e4afe1e0704250428v30ac35cfwe499a07182464fc5@mail.gmail.com>
Date: Wed, 25 Apr 2007 16:58:09 +0530
From: "Karuna sagar K" <karunasagark@gmail.com>
To: "Avishay Traeger" <atraeger@cs.sunysb.edu>
Subject: Re: Testing framework
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1177337041.3704.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2e4afe1e0704221346u6d6baec1uab88dc273ff08de9@mail.gmail.com>
	 <1177337041.3704.4.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/07, Avishay Traeger <atraeger@cs.sunysb.edu> wrote:
> On Mon, 2007-04-23 at 02:16 +0530, Karuna sagar K wrote:
> <snip>
>
> You may want to check out the paper "EXPLODE: A Lightweight, General
> System for Finding Serious Storage System Errors" from OSDI 2006 (if you
> haven't already).  The idea sounds very similar to me, although I
> haven't read all the details of your proposal.

EXPLODE is more of a generic tool i.e. it is used to find larger set
of errors/bugs in file systems than the Test framework which focuses
on the repair of file systems.

The Test framework is focused towards repairability of the file
systems, it doesnt use model checking concept, it uses replayable
corruption mechanism and is user space implementation. Thats the
reason why this is not similar to EXPLODE.

>
> Avishay
>
>

Thanks,
Karuna
