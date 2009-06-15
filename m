Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZFOJze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZFOJze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZFOJzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:55:23 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59384 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZFOJzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:55:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=YAs7TPPKY6zML6WGrfF/jwEZoIwiKiCK292rpN00jnTOQ208CEvhUycWUzTbvCuN2
	RIli/U5AYbPQ7HjCSwsWQ==
MIME-Version: 1.0
In-Reply-To: <20090615085216.GC10822@elf.ucw.cz>
References: <1245033557-10968-1-git-send-email-swetland@google.com>
	 <1245033557-10968-2-git-send-email-swetland@google.com>
	 <20090615085216.GC10822@elf.ucw.cz>
Date: Mon, 15 Jun 2009 02:55:15 -0700
Message-ID: <a55d774e0906150255h781f7677w9d336257c89200fc@mail.gmail.com>
Subject: Re: [PATCH 1/3] [ARM] msm_serial: serial driver for MSM7K onboard 
	serial peripheral.
From: Brian Swetland <swetland@google.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Robert Love <rlove@google.com>,
       Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 1:52 AM, Pavel Machek<pavel@ucw.cz> wrote:
>
> Otherwise seems to be okay (plus the issues someone pointed in other
> email), you can add my acked-by:. I guess you should submit it to
> rmk's patch system...

Russell,

Do you want this stuff to end up in the patch system, or would
accumulating patches into a for-rmk git branch somewhere make sense?
That seemed to work reasonably well last time around.  I'm happy to do
either, but am most comfortable working with git.

Does that even make sense for stuff like the serial driver or should
everything outside of arch/arm/... be going through various different
subsystem maintainers?

Thanks,

Brian
