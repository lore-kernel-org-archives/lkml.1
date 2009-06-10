Return-Path: <linux-kernel-owner+w=401wt.eu-S1758494AbZFJUJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494AbZFJUJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 16:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZFJUJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 16:09:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:55547 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759658AbZFJUJK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 16:09:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=cvIeainWNOb0FJcyJAID2Uhs6yNcdBO0CWUapAv3yePo+RlwJ2fhBXMtDMxgS6HNF
	qbLBfuhO/DNd5DlxpwihQ==
MIME-Version: 1.0
In-Reply-To: <4A301078.2050103@mlbassoc.com>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com>
	 <4A301078.2050103@mlbassoc.com>
Date: Wed, 10 Jun 2009 13:09:07 -0700
Message-ID: <a55d774e0906101309y4033d90akad513b0d487b89b7@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Gary Thomas <gary@mlbassoc.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 12:58 PM, Gary Thomas<gary@mlbassoc.com> wrote:
> Brian Swetland wrote:
>> On Wed, Jun 10, 2009 at 3:31 AM, Pavel Machek<pavel@ucw.cz> wrote:
>>> Hi!
>>>
>>> Is there patch for Dream support for 2.6.30 somewhere? The best I
>>> could find is linux-msm tree, which is ... quite a big diff against
>>> 2.6.24:
>>
>> Our current working tree (for the donut branch) is against 2.6.29:
>> http://android.git.kernel.org/?p=kernel/msm.git;a=shortlog;h=refs/heads/android-msm-2.6.29
>
> How do I turn this URL into a 'repo init' command?  The boilerplate on
> the web view just doesn't explain it to me.

Not sure on the repo details, but if you want to check the kernel code
out using git, you can:

% git clone git://android.git.kernel.org/kernel/msm.git
% cd msm
% git checkout -b android-msm-2.6.29 origin/android-msm-2.6.29

Brian
