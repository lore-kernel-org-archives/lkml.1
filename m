Return-Path: <linux-kernel-owner+w=401wt.eu-S935063AbZDBGB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935063AbZDBGB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934930AbZDBGBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:01:04 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37464 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934722AbZDBGBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:01:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KXzH/dyfdA9DiVsc+y8Dr7dYf/lstgtwIYSG4WUhuaAazKvNS0u/d5gPhEqX/Jr49P
         6gOdVlZJbj2zCCN3qPgCbZC6K5YIQ+yldqYgvDL2VvbE9gs7QmW/6/IjRsKxDZgkP5v/
         VzJ8ckAb+sXP7nB5baHm4b55E7BcmgOckOjNw=
MIME-Version: 1.0
In-Reply-To: <20090402055906.GH1117@x200.localdomain>
References: <20090331150218.GS9137@random.random>
	 <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws>
	 <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws>
	 <20090402012215.GE1117@x200.localdomain>
	 <49D424AF.3090806@codemonkey.ws>
	 <20090402054816.GG1117@x200.localdomain>
	 <36ca99e90904012257j5f5e6e2co673ff2433d49b7b9@mail.gmail.com>
	 <20090402055906.GH1117@x200.localdomain>
Date: Thu, 2 Apr 2009 08:00:56 +0200
Message-ID: <36ca99e90904012300s57c9f030xa70f028216c3da2a@mail.gmail.com>
Subject: Re: [PATCH 4/4 alternative userspace] add ksm kernel shared memory 
	driver
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Chris Wright <chrisw@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, riel@redhat.com, jeremy@goop.org, mtosatti@redhat.com,
       hugh@veritas.com, corbet@lwn.net, dmonakhov@openvz.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 07:59, Chris Wright <chrisw@redhat.com> wrote:
> * Bert Wesarg (bert.wesarg@googlemail.com) wrote:
>> > Unregister a shareable memory region (not currently implemented):
>                                          ^^^^^^^^^^^^^^^^^^^^^^^^^
>> > madvise(void *addr, size_t len, MADV_UNSHAREABLE)
>> I can't find a definition for MADV_UNSHAREABLE!
>
> It's not there ;-)
>
Thanks ;-)
