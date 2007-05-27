Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbXE0QIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbXE0QIE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 12:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbXE0QHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 12:07:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:28894 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbXE0QHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 12:07:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TAggx8bi3VbuJYpMiiyLmtCb4Ox4WccaZ0jHiYGj+YruYNL5mkoThCG52zRRTYXHL/AVrUeGJLxi+IatKbc3fGDvAheW+b+7pbxl7IEJxjQ9AL8Fe+kgmCzH58xd+WpUI/3CFmTiJ/LWvt/v96FqSqRsWOHKwsBcT6V5aswYcHU=
Message-ID: <9d2cd630705270907y4722653cpf79f073fa8f12f08@mail.gmail.com>
Date: Sun, 27 May 2007 18:07:50 +0200
From: "Gregor Jasny" <gjasny@googlemail.com>
To: "Jeff Garzik" <jgarzik@pobox.com>
Subject: Re: Linux v2.6.22-rc3
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <46599E6B.1000209@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
	 <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>
	 <46599E6B.1000209@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/27, Jeff Garzik <jgarzik@pobox.com>:
> Does the attached patch fix things?

No it doesn't. Note that I'm using ata_piix.

Gregor
