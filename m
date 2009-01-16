Return-Path: <linux-kernel-owner+w=401wt.eu-S1763803AbZAPPU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763803AbZAPPU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZAPPUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:20:10 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:41517 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbZAPPUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:20:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Yh2UKu4rLy/WBngf+ytAl5KCa54VdRwORXa/IRXgBbRH0poaz+aE8VusXIDixLin7W
         S7M62XqraUT/WgbXzAGsZnxgpI4f4DRPVwQ+4RP3bpv+eAJdsUFYIuFc2OXoJB9/bNoV
         xOK2b9WhE1WNGL5mBMzOpvRlgIg0s1Kz/eJM0=
MIME-Version: 1.0
In-Reply-To: <1232116274.21473.15.camel@think.oraclecorp.com>
References: <49703687.044e6e0a.04fa.257b@mx.google.com>
	 <1232116274.21473.15.camel@think.oraclecorp.com>
Date: Fri, 16 Jan 2009 23:20:06 +0800
Message-ID: <9bd6b5360901160720w3a2950eemaf2cd3e35caec788@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: simplify iteration codes
From: sniper <s3c24xx@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Qinghuang Feng <qhfeng.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 10:31 PM, Chris Mason <chris.mason@oracle.com> wrote:
> On Fri, 2009-01-16 at 15:25 +0800, Qinghuang Feng wrote:
>> merge list_for_each and list_entry to list_for_each_entry.
>>
>
> Thanks, I've queued this up.
>
Good, but....

Now I have made a new patch for cleanupping all the similar codes in btrfs.
This patch has been tested in VM, it seems ok.

Now should I  rebuild another patch which based the previous patch,
or could you be able to reverse the previous patch then I just post
this new patch including all stuff?

Sorry I am not much familiar with the posting flow, and I am not sure
the meaning of "queued".
