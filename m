Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbZFKMpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbZFKMpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZFKMpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:45:35 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:37481 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbZFKMpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:45:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Gdm+TWiTFL+E7pabWV0NWv63MLI44bcwWq+kYBpadgDBibSBjjph1uNxWPEwDkVeOb
         wbAxY/yADrvVSJf3Z9sI75Dc5OzX3frn+KUVcuSBIIsHLxhXr1SJ0PnPBLhvBl0wQd2y
         G7vTRWs0RCdyVIiX/YUrHuu7jWJbBJjva7T6I=
MIME-Version: 1.0
In-Reply-To: <20090611110946.GA7523@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com>
	 <20090611081012.GD8592@elf.ucw.cz>
	 <a55d774e0906110127k1633dd90x96863c3dd6f888cf@mail.gmail.com>
	 <20090611110946.GA7523@elf.ucw.cz>
Date: Thu, 11 Jun 2009 08:45:36 -0400
X-Google-Sender-Auth: 2231c7851f0fb1b7
Message-ID: <b6c5339f0906110545l5ced1039tf7baac3fab2450e2@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       ibm@android.com, san@android.com, rlove@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 7:09 AM, Pavel Machek<pavel@ucw.cz> wrote:
> Anyway, now I have a tree, and yes it compiles. (After some
> "interesting" questions; perhaps defconfig should be updated?)

> ...and I just selected "3" being default. No help available :-(. I
> have cupcake installed, and I believe I installed radio update
> required for cupcake. Can someone help?

I can send you my .config if you want, I have it working.

Note you need the latest userland because the initrd details changed
a bit (e.g. a 2.6.29 kernel will not work on the 1.1 userland, but
will work on 1.5, something to do with mounting the filesystems, I
can't remember exactly from my serial traces.)

-- 
Bob Copeland %% www.bobcopeland.com
