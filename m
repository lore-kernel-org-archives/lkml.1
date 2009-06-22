Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbZFVHUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbZFVHUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 03:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZFVHU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 03:20:29 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:62871 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbZFVHU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 03:20:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=duH5L0/u0eW/fjqAgUStJvQNhQut5WcdQga07YLcWAZNcHNOEr3MtgpONIVb8qV2lW
         NApFcqeT9zM2gTxiLisrZUQJ08wcVtjk2UNbbjUTDu9a+af8whY5eY0cVzfiTz9mCDZv
         VzBIwptY39e698e5ZigR+FUUy8V6YYCKsvhcU=
MIME-Version: 1.0
In-Reply-To: <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
	 <4A3E7F38.7030300@linux.intel.com>
	 <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com>
	 <4A3EE668.5090400@jp.fujitsu.com>
	 <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>
Date: Mon, 22 Jun 2009 09:20:29 +0200
Message-ID: <8db1092f0906220020x4b84974bl39aef7d31bcc2b17@mail.gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to 
	disk, mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <ak@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/22 Maciej Rutecki <maciej.rutecki@gmail.com>:

> _But_ still system hangs after resume and during s2disk (while use
> echo 0 > /sys/devices...)

Should be: echo 1 > /sys/devices...


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
