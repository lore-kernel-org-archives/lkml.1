Return-Path: <linux-kernel-owner+w=401wt.eu-S1765088AbZFLWoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765088AbZFLWoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762131AbZFLWn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:43:56 -0400
Received: from smtp-out.google.com ([216.239.45.13]:63265 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761173AbZFLWny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:43:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=WfMlIWdwcqHoBMPQ0o9TfTLNWV85XnBmvaTBsPZpDVD5Wv2AdQPps//7xNUmF/d9Z
	sZOmBuEEJVYVz6j338oSA==
MIME-Version: 1.0
In-Reply-To: <a55d774e0906121542g182d4814udd66c2d1ebf57cf5@mail.gmail.com>
References: <a55d774e0906121450x12bab7b0sc1f4de0115a1af61@mail.gmail.com> 
	<20090612222229.GE17688@elf.ucw.cz> <1cc472780906121538h5b70fa4dg891ff729fda1a566@mail.gmail.com> 
	<a55d774e0906121542g182d4814udd66c2d1ebf57cf5@mail.gmail.com>
From: Shawn Pearce <sop@google.com>
Date: Fri, 12 Jun 2009 15:43:34 -0700
Message-ID: <1cc472780906121543l20ceb412kf93f7f73b1f6fe79@mail.gmail.com>
Subject: Re: Gerrit (was Re: HTC Dream aka. t-mobile g1 support)
To: Brian Swetland <swetland@google.com>
Cc: Pavel Machek <pavel@ucw.cz>, Stefan Schmidt <stefan@datenfreihafen.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Greg KH <greg@kroah.com>, Chris Dibona <cdibona@google.com>,
       Daniel Berlin <dannyb@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 15:42, Brian Swetland <swetland@google.com> wrote:
> When we first discussed the CLA, I raised this concern (that the
> mainline kernel folks would not be thrilled by another system in
> addition to Signed-off-by), and was informed that we should not have
> to require CLA acceptance for contributions to the kernel/... trees.
> I'm not sure if Gerrit is setup to handle this yet.

It is, but we haven't flipped the bit on the kernel projects that says
"no CLA".  I can do that if you want me to.
