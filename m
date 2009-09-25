Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbZIYQch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbZIYQch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 12:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbZIYQcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 12:32:36 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:44399 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbZIYQcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 12:32:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mt71MBmOhZubiHMF1ui1lj8/gBoTpw1ZQwu9mmqB4d/2VkL1pm0J5pMwf3cD678XRw
         N9sQWk4LshRcz1J72zK9bWEHDZgXqRztp1X+a0E7+1dVKFRqe4kLo0vTuezYTsPeme75
         SMxNSKPF/lgXhZVtFhouar2QqPfc+TXrtvs+s=
MIME-Version: 1.0
In-Reply-To: <b6a2187b0909250900n7922f606w8b99f042b0a6f441@mail.gmail.com>
References: <b6a2187b0909240624u2821a312ub6d02df21d552248@mail.gmail.com>
	 <20090924160136.44e31ad0@lxorguk.ukuu.org.uk>
	 <b6a2187b0909240923t4e8d61f4g6d82b7f9f9bf621b@mail.gmail.com>
	 <20090925115636.5b4b8aca@linux.intel.com>
	 <b6a2187b0909250835g1b72037er13b86bf762fd5e37@mail.gmail.com>
	 <20090925164747.55dab000@lxorguk.ukuu.org.uk>
	 <4ABCE72D.5040001@xenotime.net>
	 <b6a2187b0909250900n7922f606w8b99f042b0a6f441@mail.gmail.com>
Date: Sat, 26 Sep 2009 00:32:39 +0800
Message-ID: <b6a2187b0909250932r140eca54y75b38634b853bb9@mail.gmail.com>
Subject: Re: linux-2.6.31 INIT: open(/dev/console): Input/output error (due to 
	commit b50989dc444599c8b21edc23536fc305f4e9b7d5)
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 12:00 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Fri, Sep 25, 2009 at 11:52 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> Alan Cox wrote:
>>>> Is this going into Linus's branch soon? Otherwise, please kindly post
>>>> the full patch so that I can test it instead of pulling 400MB from
>>>> Andrew's tree.
>>> I don't have Andrews tty patches here either sorry but I thought he kept
>>> them broken out on kernel.org ?
>> http://userweb.kernel.org/~akpm/mmotm/
>> see the broken-out/ subdir.
>
> I see. But that patch is not there. Did find it on google.
>
> http://www.spinics.net/lists/mm-commits/msg71772.html
>
> So, I'll test it now.

Alan, Randy,

That patch works!

Thanks,
Jeff
