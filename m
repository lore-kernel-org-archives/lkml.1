Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbZD0LEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbZD0LEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZD0LEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:04:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:61673 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZD0LEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HG9Y+/3JGOQRGkSKjUiip/4ritju3xY6QVraGC1NtPNG+X6XTHRcYd3paC+Eb3s5yX
         8UO7srDO9Hn1VTv0Pw8U/DWbZmk/n46hbqGf+KmjgXeKEmZROFGR4/zmVWfTH8tQQgcP
         oWbY+pww6lnMxeIS+cbSLiLfBCagsms0I0Png=
MIME-Version: 1.0
In-Reply-To: <1240814342.30259.41.camel@macbook.infradead.org>
References: <20090427124333.a7270ddf.h.mitake@gmail.com>
	 <1240814342.30259.41.camel@macbook.infradead.org>
Date: Mon, 27 Apr 2009 20:04:31 +0900
Message-ID: <a6b9f31a0904270404v7f19d69auf651b5a1593f5f9e@mail.gmail.com>
Subject: Re: [PATCH] ihex2fw should be ignored by scripts/.gitignore because 
	ihex2fw is in scripts directory
From: Hitoshi Mitake <h.mitake@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: jaharkes@cs.cmu.edu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 15:39, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2009-04-27 at 12:43 +0900, Hitoshi Mitake wrote:
>>
>> I found this message from git-status on not modified clone of Linus's
>> tree,
>>
>> # Not currently on any branch.
>> # Untracked files:
>> #   (use "git add <file>..." to include in what will be committed)
>> #
>> #       scripts/ihex2fw
>> nothing added to commit but untracked files present (use "git add" to
>> track)
>
> Actually, ihex2fw should never have been moved from the firmware/
> directory to scripts/. I've already moved it back, so the .gitignore
> files are correct as they are.
>

I didn't know that. Thanks.
