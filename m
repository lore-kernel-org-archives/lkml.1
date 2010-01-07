Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272Ab0AGQfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab0AGQfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965Ab0AGQfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:35:10 -0500
Received: from outbound-mail-38.bluehost.com ([69.89.20.192]:36483 "HELO
	outbound-mail-38.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752952Ab0AGQfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:35:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KdJHLeUqdkIlwtoYuVd4wzotQAHEf7o4MHTtk0iZVVU2vXLzvJ+4bjYqrjMM3csG3NMbG9S1YmrZEO8ToYJtIOEO91fuPFzhgJSuU0x0/8aanezMFv3XHbZSrdKOjvAa;
Date: Thu, 7 Jan 2010 08:35:06 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: davidjon@xenontk.org
Cc: airlied@gmail.com, linux-kernel@vger.kernel.org, eric@anholt.net,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH v2] drm: Keep disabled outputs disabled after suspend /
 resume
Message-ID: <20100107083506.3049aaf4@jbarnes-piketon>
In-Reply-To: <4B45931E.3000902@xenontk.org>
References: <4B3C24BC.3040906@xenontk.org>
	<1262241046-3740-1-BlackWidow-davidjon@xenontk.org>
	<4B45931E.3000902@xenontk.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jan 2010 13:24:06 +0530
David John <davidjon@xenontk.org> wrote:

> On 12/31/2009 12:00 PM, David John wrote:
> > With the current DRM code, an output that has been powered off
> > from userspace will automatically power back on when resuming
> > from suspend. This patch fixes this behaviour.
> > 
> > Tested only with the Intel i915 driver on an Intel GM45 Express
> > chipset.
> > 
> > Signed-off-by: David John <davidjon@xenontk.org>
> 
> Ping.
> 
> Any update on this? Correct? Incorrect? Utter rubbish that I should be
> ashamed of myself?

Yeah, sorry David, looks good to me.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
