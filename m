Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZGBJS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZGBJS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZGBJSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:18:47 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:37167 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZGBJSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tkYJZMKOAEbco1oR9Sxm9NPb4wvdKlRyrc7767+p5dC5Oe/w6JHBGk11EdhRnuoRCo
         o/Wa5nsOFuR7JNWTfDN/YX1FqMKiqrzuAfmQL5VgGn2aEialbwF9etSdZyMru4IJY82q
         766qprww7sZvRNXR2whe4J9HLx22GlxA5GLPk=
MIME-Version: 1.0
In-Reply-To: <20090702091309.GB6372@cr0.nay.redhat.com>
References: <412e6f7f0907020036y76abbc7du99c7b695f725be4@mail.gmail.com>
	 <20090702091309.GB6372@cr0.nay.redhat.com>
Date: Thu, 2 Jul 2009 17:18:49 +0800
Message-ID: <412e6f7f0907020218m1f4a9651l2c682a9905925bcd@mail.gmail.com>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
From: Changli Gao <xiaosuo@gmail.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 5:13 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
> On Thu, Jul 02, 2009 at 03:36:41PM +0800, Changli Gao wrote:
>
> Why? Why do you need this feature?
>
Are you familiar with splice() and tee()? They both use pipes as kernel buffers.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
