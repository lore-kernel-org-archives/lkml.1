Return-Path: <linux-kernel-owner+w=401wt.eu-S936104AbXJPUyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936104AbXJPUyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934624AbXJPUya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:54:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:47478 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759551AbXJPUy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:54:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=IMMWld5OmYdBy3ZnKjQLqFFBmuxv4nJZt1iQ1bm8EGtdP1zHfXMyW5XgdP8KG0V+T8X3ZZrHAD7iI7uwbeLLU3zTb+xl9XabVvVzWLgw1yTxwu4ahOSeM+a8aqexUaOqkbaYMw9i/nRWnnQxrge6P9m0GDfKUGNSVOe+SPF2nhQ=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andreas Schwab <schwab@suse.de>
Subject: Re: In response to kernel compression e-mail a few months ago.
Date: Tue, 16 Oct 2007 21:54:21 +0100
User-Agent: KMail/1.9.1
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Al Viro <viro@ftp.linux.org.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       apiszcz@solarrain.com
References: <Pine.LNX.4.64.0710141533080.3935@p34.internal.lan> <200710161419.07975.vda.linux@googlemail.com> <jebqazjidr.fsf@sykes.suse.de>
In-Reply-To: <jebqazjidr.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710162154.21390.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2007 14:31, Andreas Schwab wrote:
> Denys Vlasenko <vda.linux@googlemail.com> writes:
> 
> > I'm with Al on this. 50 Mb for decompression?
> > Embedded and small device folks will not love this, I'm sure.
> 
> How often do you unpack the kernel sources on an embedded device? :)

Oops. I goofed up, I somehow thought we were talking about kernel _images_
being compressed. :(
--
vda
