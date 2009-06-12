Return-Path: <linux-kernel-owner+w=401wt.eu-S934505AbZFLWrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505AbZFLWrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934167AbZFLWpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:45:17 -0400
Received: from smtp-out.google.com ([216.239.45.13]:63384 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934124AbZFLWpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:45:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=gZiqQHkBTf+odiipk30MTKMlLJSq0L5Kp3Hy3bD3R2613ZD2kCD/JwOPpoOuDgxEU
	fo3yL8cix82s8qrE6p0sA==
MIME-Version: 1.0
In-Reply-To: <1cc472780906121543l20ceb412kf93f7f73b1f6fe79@mail.gmail.com>
References: <a55d774e0906121450x12bab7b0sc1f4de0115a1af61@mail.gmail.com>
	 <20090612222229.GE17688@elf.ucw.cz>
	 <1cc472780906121538h5b70fa4dg891ff729fda1a566@mail.gmail.com>
	 <a55d774e0906121542g182d4814udd66c2d1ebf57cf5@mail.gmail.com>
	 <1cc472780906121543l20ceb412kf93f7f73b1f6fe79@mail.gmail.com>
Date: Fri, 12 Jun 2009 15:45:15 -0700
Message-ID: <a55d774e0906121545y21fbfe8ftd7cce160e7a43581@mail.gmail.com>
Subject: Re: Gerrit (was Re: HTC Dream aka. t-mobile g1 support)
From: Brian Swetland <swetland@google.com>
To: Shawn Pearce <sop@google.com>
Cc: Pavel Machek <pavel@ucw.cz>, Stefan Schmidt <stefan@datenfreihafen.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Greg KH <greg@kroah.com>, Chris Dibona <cdibona@google.com>,
       Daniel Berlin <dannyb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 3:43 PM, Shawn Pearce<sop@google.com> wrote:
> On Fri, Jun 12, 2009 at 15:42, Brian Swetland <swetland@google.com> wrote:
>> When we first discussed the CLA, I raised this concern (that the
>> mainline kernel folks would not be thrilled by another system in
>> addition to Signed-off-by), and was informed that we should not have
>> to require CLA acceptance for contributions to the kernel/... trees.
>> I'm not sure if Gerrit is setup to handle this yet.
>
> It is, but we haven't flipped the bit on the kernel projects that says
> "no CLA".  I can do that if you want me to.

Please do.  Thanks!

Brian
