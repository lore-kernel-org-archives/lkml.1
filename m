Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbZHXXeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbZHXXeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbZHXXeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:34:05 -0400
Received: from mail-yw0-f183.google.com ([209.85.211.183]:61092 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbZHXXeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o5865iCvS8A2DF6mRyBEWzGZ6PnYVnv2TW4kRoKYNHTV8D6sBD5Hbttt+U8T0pH8D9
         mqv0Yj2mnr8I1tHDLRR3S6/FVfd3ROQ1NZSsqM+eeOZ3FVnfEsWLOKr57I8ZHCUje+y0
         UrWxIwCOKlXe3AvgcKK0CV+oOhTyIfgL4E/sM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0908241534250.6699@gandalf.stny.rr.com>
References: <4A84345D.60506@gmail.com> <20090818104905.GC5231@nowhere>
	 <20090818160911.GA21243@goodmis.org>
	 <dd18b0c30908180924n3848d32ave258f98a5f703c38@mail.gmail.com>
	 <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com>
	 <4A8B4607.6090303@gmail.com> <4A8B5113.20102@cn.fujitsu.com>
	 <4A8FA2BD.4030707@gmail.com>
	 <alpine.DEB.2.00.0908241534250.6699@gandalf.stny.rr.com>
Date: Mon, 24 Aug 2009 16:34:03 -0700
Message-ID: <dd18b0c30908241634v507c6c27qc3ad8784c20f4532@mail.gmail.com>
Subject: Re: system gets stuck in a lock during boot
From: Justin Mattock <justinmattock@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 12:42 PM, Steven Rostedt<rostedt@goodmis.org> wrote:
>
> On Sat, 22 Aug 2009, Justin P. Mattock wrote:
>> I must admit, I've been afraid of doing
>> a git bisect for some time now. but after learning
>> to do a bisect, I cant see a better solution to finding a
>> bug(biggest issue I see is having a huge .config).
>
>  http://rostedt.homelinux.com/code/streamline_config.pl

ahh noway!!  finally a nice and small .config
Ill try it out.
>
> It will remove any module from your config that is not loaded. Makes
> compiling kernels much faster.
>
> (also featured in LWN this week: http://lwn.net/Articles/347713/)
>
> -- Steve
>
>

Ill have to look at that feature.
(need to register).

-- 
Justin P. Mattock
