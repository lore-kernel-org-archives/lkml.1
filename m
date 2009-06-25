Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbZFYTbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbZFYTbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZFYTbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:31:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:15865 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbZFYTbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:31:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=gefOocsokDJ/JEj4WU2BtFQDO4qPm9B0tholevlE2zvE64ymXkNNnNNv6Tiv4m8j1
	5a2V1Vzg13xBoMUuTOXKQ==
MIME-Version: 1.0
In-Reply-To: <20090625135532.GB11875@n2100.arm.linux.org.uk>
References: <1245033557-10968-1-git-send-email-swetland@google.com>
	 <1245033557-10968-2-git-send-email-swetland@google.com>
	 <1245033557-10968-3-git-send-email-swetland@google.com>
	 <1245033557-10968-4-git-send-email-swetland@google.com>
	 <20090615132248.GB14555@elf.ucw.cz>
	 <a55d774e0906151125h36ee7c36yb9ecf5fb3fb8e41b@mail.gmail.com>
	 <20090615182850.GA10490@elf.ucw.cz>
	 <a55d774e0906151151p223895b1pc01be38e1d0e9358@mail.gmail.com>
	 <20090624205618.GD9149@elf.ucw.cz>
	 <20090625135532.GB11875@n2100.arm.linux.org.uk>
Date: Thu, 25 Jun 2009 12:31:03 -0700
Message-ID: <a55d774e0906251231m4937c65aia3698dbd85427bac@mail.gmail.com>
Subject: Re: [PATCH 3/3] [ARM] msm: add minimal board file for HTC Dream 
	device
From: Brian Swetland <swetland@google.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 6:55 AM, Russell King - ARM
Linux<linux@arm.linux.org.uk> wrote:
> On Wed, Jun 24, 2009 at 10:56:19PM +0200, Pavel Machek wrote:
>> Are there any issues that prevent this from being merged? Russell, can
>> you take those patches?
>
> I thought Alan's preference was for me to be out of the loop on machine
> specific stuff, and for platform maintainers to push their stuff directly
> into linux-next and to Linus.
>
> If people do want to push stuff via me, that's fine, but they're going to
> have to explicitly ask for it.  If they don't, that's also fine.  (There
> are those who clearly stated that they want my continued involvement and
> review.)

I wasn't sure when/how the process would change here.  Could somebody
point me at any up to date information on how/where to send stuff to
linux-next?

I'm still interested in sending patches past lakml/lkml for review
though -- I've received very useful feedback from previous patches
this way in the past.  Presumably (for arch/arm/mach-msm/...) I could
send patch series out for review, adjust them as necessary based on
feedback, and assemble into a git branch suitable for linux-next?

Thanks,

Brian
