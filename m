Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbZAHEkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbZAHEkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZAHEkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:40:07 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:5845 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbZAHEkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:40:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TkurSxQ+lz27HaY59p1lvYAVePCd/SVH9aAMP8pGinQQ6ht0nG0vDKY26qBUTcrGQ7
         kWz34jYlgNO5D04wQT3+dd8l5kv9hpNXPWtf+vciza9e6fT7G+YLgDsqovLn7en3NlyK
         vTWoEarEUKDYmKzIHEQpkWw0y1blIDgf29VgQ=
Message-ID: <3f9a31f40901072040x4e1e3be9vece333b19a24a645@mail.gmail.com>
Date: Thu, 8 Jan 2009 10:10:04 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Andy Whitcroft" <apw@canonical.com>
Subject: Re: scripts/checkpatch.pl : undefined value as an ARRAY reference
Cc: davej@redhat.com, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20090107235037.GF12402@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40901070454x678f75d2xee2a6de04a940321@mail.gmail.com>
	 <20090107130742.GD2520@shadowen.org>
	 <3f9a31f40901070527y31fcccc9n5b3d52faa58e359e@mail.gmail.com>
	 <20090107235037.GF12402@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 5:20 AM, Andy Whitcroft <apw@canonical.com> wrote:
>
> Thanks thats great.  I think I have this fixed in my tree now.  Can you
> test with the version at the url below:
>
>  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing
>

Thanks Andy, this works for me.

--
JSR
