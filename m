Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbYJVSAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbYJVSAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYJVR7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:59:55 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59661 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbYJVR7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Vksn8J5CllTonNx1Y4Jv0yXu/p4RfljetbgTVst3S28lH0edG2aBGAllI1olPZ5AvB
         qMRiVbGNEKn9Nbb2u8HGBNqRvwiMT6F46L1kIpdk9clXWM7tH94Y4fQ2QmSsRk5Lvyip
         sEK2GT3krrrNcFUCA0DwzF5XnDtu8ZmV3i4DY=
Message-ID: <81b0412b0810221059w2e02b1c1ubd894b22f7991242@mail.gmail.com>
Date: Wed, 22 Oct 2008 19:59:53 +0200
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Markus Rechberger" <mrechberger@gmail.com>
Subject: Re: [PATCH] em28xx patches against the latest git tree
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx@mcentral.de
In-Reply-To: <d9def9db0810221038g156871e1u200abb90b774ad28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221034v3bf4dabt6aa905b8a3ebd5a@mail.gmail.com>
	 <d9def9db0810221038g156871e1u200abb90b774ad28@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/22 Markus Rechberger <mrechberger@gmail.com>:
>> commit history is available at:
>> http://mcentral.de/http://git.kernel.org/?p=linux/kernel/git/mrec/linux-2.6.git;a=commit;h=f1be9ae8f8489a6598417a194e0899ac00c7530ehg/~mrec/em28xx-new
>>
>
> this should be:
> http://mcentral.de/hg/~mrec/em28xx-new/shortlog
>

There is already an Empia EM28XX driver in the official tree. If your driver
is based on it, could you point at the first commit in *your* tree at
mcentral.de which
corresponds to that driver? (if you do, your history can be moved into
central Git
repo completely, every commit of it)
