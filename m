Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbZATDeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbZATDeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 22:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbZATDe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 22:34:28 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:47273 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbZATDe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 22:34:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gSr29FQsuEx3cCx3ddpe0ouK4Fwu5Y6iBiLfBdz3ZVaaGvsndW7ZiWjuHA2bzJJ3cx
         ReW18fKnAh5w0wFjnuQ6OZ/1HJIvpygUsXWO/MZk4hApXagcNcFMl3NeCY4N0o9is3uO
         Fz0RH56SN5X5wrpe153Vp876ohEOt+hunCJqQ=
Message-ID: <49754643.5030000@gmail.com>
Date: Tue, 20 Jan 2009 12:34:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET x86:core/percpu] percpu: move PDA fields to percpu
References: <1232296759-2253-1-git-send-email-tj@kernel.org> <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com> <4973E938.4010408@kernel.org> <20090119111932.GC18996@elte.hu> <20090119113530.GA13185@elte.hu> <4974838F.4020606@kernel.org>
In-Reply-To: <4974838F.4020606@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> Would you mind to redo these commits on top of that? I tried the conflict 
>> resolution but it looks quite complex and non-obvious - it would be 
>> cleaner to have it this way.
> 
> Sure, will rebase and repost.

Okay, updatd & rebased (6b7c38d55587f43bcd2cbce3a98b1c0826982090).

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Thanks.

-- 
tejun
