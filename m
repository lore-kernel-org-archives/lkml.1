Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbYGSEqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbYGSEqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 00:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYGSEp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 00:45:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:49579 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYGSEp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 00:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Yh9NYS8KjHoim5V2QhUdnHu/BNyQqI/I89uUjrmNph31z/yjKY9GFhCOj43URziTsa
         tI0phvzl+e9MluMy09tx3azlALXz7hU/fZ/hyQOSHMZyIpeqWa0uFZr6IOkCosBnp7Bh
         CnS3OyjHvTAhEkUjseOF8A7vTDeZzqh0B9eqI=
Message-ID: <86802c440807182145qa3d17e9k210c498109d86b58@mail.gmail.com>
Date: Fri, 18 Jul 2008 21:45:55 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: macbook2,2 latest git mmconfig issues
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jack Howarth" <howarth@bromo.msbb.uc.edu>
In-Reply-To: <dd18b0c30807182039u3e590e50p5d76624dd9e5b1d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30807182039u3e590e50p5d76624dd9e5b1d8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 8:39 PM, Justin Mattock <justinmattock@gmail.com> wrote:
> Hello;
> Well I couldn't really see what was happening
> until I could experience this myself;
> It seems the macbook pro ati chipset
> is having the same problem as jack was with mmconfig yesterday.
> I'm confused as to why my system was able to run this kernel(2.6.26.git1)
> without a problem, now after doing a reinstall of the operating system
> I am confronted with this same issue. How do I find the 0x3f number on
> my system,
> so I could plug that into the patch? to see if I can boot up
> Now keep in mind the only difference with this install is the
> installer took a dump
> therefore you have to manually install grub(could this be the source
> of the issue?)
> regards;

can you disable ASPM in your config.?

YH
