Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZEZF4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZEZF4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 01:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbZEZF4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 01:56:41 -0400
Received: from mail-px0-f103.google.com ([209.85.216.103]:32925 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbZEZF4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 01:56:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q1H1CeTErgf0DgwRbLp9ft8tEXKueCvRS8xc71ycgbwwx32oKOjNLl7IJ8Kr6jsVJF
         Dc9KRdWPhEGwpeX+22ZkZBEU7KP9m4tK/XVxozF5c0JACgZpbiiszwcK/C/UsO74i71v
         PcwDlPFRW2smUQt9FFBVMOrfxbFd2BsLq4Vi8=
MIME-Version: 1.0
In-Reply-To: <49b7c2350905251445n14397b82yc993f1a86d715d4d@mail.gmail.com>
References: <f24d23310905250956u231fcd90u54d75894b9b91b9a@mail.gmail.com>
	 <49b7c2350905251445n14397b82yc993f1a86d715d4d@mail.gmail.com>
Date: Tue, 26 May 2009 11:26:42 +0530
Message-ID: <f24d23310905252256h74d609d9l7e23b1cdc0a240c6@mail.gmail.com>
Subject: Re: Unable to compile 2.6.30-rc7 on RHEL 4 - GCC 3.4.6
From: debian developer <debiandev@gmail.com>
To: GeunSik Lim <leemgs1@gmail.com>
Cc: linux kernel <kernelnewbies@nl.linux.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 3:15 AM, GeunSik Lim <leemgs1@gmail.com> wrote:
> Hi,
>
> If you keep gcc 3.X.X to compile recent kernel source contiunally,
> You will meet another problems again.
>

OK, so 3.x.x is officially not supposed to be used for compilation?
