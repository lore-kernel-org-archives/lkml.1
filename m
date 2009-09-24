Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZIXQX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZIXQX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZIXQX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:23:26 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:65126 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZIXQX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:23:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sI0WNAtKKFJckkJ8Aexl1MB2sRCW5AeD3MxDS7xsL+K2WTa7wjnmDhM/mbMIerDyYL
         WzALOmJW6lCc96J77GOs6G7ZAgNvE+UrGogNAhIW1347BzFqjjt6IAeT2F3IJjAQOdl5
         wRJKjQNOSEbScPKrgUYxJJqUfoMcBFuyv3lBE=
MIME-Version: 1.0
In-Reply-To: <20090924160136.44e31ad0@lxorguk.ukuu.org.uk>
References: <b6a2187b0909240624u2821a312ub6d02df21d552248@mail.gmail.com>
	 <20090924160136.44e31ad0@lxorguk.ukuu.org.uk>
Date: Fri, 25 Sep 2009 00:23:27 +0800
Message-ID: <b6a2187b0909240923t4e8d61f4g6d82b7f9f9bf621b@mail.gmail.com>
Subject: Re: linux-2.6.31 INIT: open(/dev/console): Input/output error (due to 
	commit b50989dc444599c8b21edc23536fc305f4e9b7d5)
From: "jeff.chua.linux" <jeff.chua.linux@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 11:01 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> It is timing dependant. A discussion and some fixes were posted a while
> ago.

I must have missed that. Will try to search for it.

Thanks,
Jeff
