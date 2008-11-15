Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbYKOU2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbYKOU2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 15:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYKOU2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 15:28:46 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:34144 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbYKOU2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 15:28:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BtmnRYZgmj5CEvNK4tImIGoa/QJRBqkBhvvhX51EQqSo9IcTu8KF2gWMOffG5WvG+c
         zkkXU6Dl7MyoIPkc4j1FrbJTX9pK8b0QqWyDV1fQUQ4u27ho5prmMhvihF/CqB1HNMge
         pA6vSR4zMn/R6V7EY/TTSLCCULBNZAqmya7VM=
Message-ID: <a4e6962a0811151228h14679d35m56eceff433e518f9@mail.gmail.com>
Date: Sat, 15 Nov 2008 14:28:45 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] bug fixes for 9p linux-2.6.28-rc4
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0811151139190.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4e6962a0811141425n119d624bk8a1a0e3b9c3a9eab@mail.gmail.com>
	 <alpine.LFD.2.00.0811151139190.3468@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry - just cut n' pasted the output of git-request-pull, didn't
notice it didn't tag on a diffstat, maybe I have an old buggy version
of git.

            -eric


On Sat, Nov 15, 2008 at 1:40 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 14 Nov 2008, Eric Van Hensbergen wrote:
>>
>> The following changes since commit 4ff429e658c00bcf5101eabbebd4f711572a64cb:
>>   Randy Dunlap (1):
>>         9p: restrict RDMA usage
>>
>> are available in the git repository at:
>>
>>   ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus
>
> Diffstat?
>
> Yeah, I see that it is
>
>  net/9p/Kconfig |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
>
> but I want to know things like that _before_ pulling, just to know what to
> expect, and so that I know that what I pull is what you meant me to pull.
>
>                Linus
>
