Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbXGNJhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbXGNJhp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 05:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbXGNJhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 05:37:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:17424 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbXGNJhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 05:37:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=FOCYSontrGJ4j0/l3zTcM13fV1gzME+EHEQvOi32ldrnG6od13zt+xXg45A8dwU9LdWN6Fu9v9TghOFu9vTRM8vZuVZNll0IBZqRA5/7nAqN1jgGz79KrKshb3+QiQRxe6mpdCv8wkOCbjEYQp7gn4WE+22gQGmpYir0K22UgV8=
Date: Sat, 14 Jul 2007 17:40:13 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Anand Jahagirdar <anandjigar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Patch Related with Fork Bombing Attack
Message-ID: <20070714094013.GB3929@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <25ae38200707130539j3b6689eet91bff4298023aa28@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25ae38200707130539j3b6689eet91bff4298023aa28@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 06:09:02PM +0530, Anand Jahagirdar wrote:
>Hello All

{snip}

>Index: root/Desktop/a1/linux-2.6.17.tar.bz2_FILES/linux-2.6.17/kernel/fork.c
>===================================================================
>--- root.orig/Desktop/a1/linux-2.6.17.tar.bz2_FILES/linux-2.6.17/kernel/fork.c	2007-06-26 20:40:06.000000000 +0530
>+++ root/Desktop/a1/linux-2.6.17.tar.bz2_FILES/linux-2.6.17/kernel/fork.c	2007-06-26 20:41:41.000000000 +0530

Please make your patch be in `patch -p1' form.

See: http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt to learn more.

Regards!

-- 

If loving computers is wrong, I don't want to be right.
