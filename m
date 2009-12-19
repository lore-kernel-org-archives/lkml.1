Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZLSXRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZLSXRX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 18:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZLSXRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 18:17:22 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39951 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbZLSXRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 18:17:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=whmzcT5d2iiNFJB86Mb9oKZFg1ers7b9Igrpv0gjxK7KgGIqMwrCgYxkWsuRROxgBX
         LlTYiwP/oslCrAOWX169p2qGcQwYDm0yGvE2vPqM6WsKEMCVk/rJGq61IvSVOQiNjEwz
         g47BEQgQjK1h5REDHHy//YaZT2bfbVoZn/ddQ=
MIME-Version: 1.0
In-Reply-To: <20091219215439.GA9011@elf.ucw.cz>
References: <20091219215439.GA9011@elf.ucw.cz>
Date: Sun, 20 Dec 2009 00:17:19 +0100
Message-ID: <81b0412b0912191517m462dc9c4k3cec254ad3fdc4c7@mail.gmail.com>
Subject: Re: 2.6.33-git0 regression: hard lock when connecting openmoko
From: Alex Riesen <raa.lkml@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, greg@kroah.com,
       linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
       Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 22:54, Pavel Machek <pavel@ucw.cz> wrote:
> ...that's pretty much it. It says "New high speed usb device" and
> cursor stops blinking :-(.

Maybe this is related: http://lkml.org/lkml/2009/8/2/100 ?
