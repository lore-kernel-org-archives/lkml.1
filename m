Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbZANO3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbZANO3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbZANO3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:29:13 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:58491 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbZANO3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:29:12 -0500
Message-ID: <496DF66B.3050609@dawes.za.net>
Date: Wed, 14 Jan 2009 16:27:55 +0200
From: Rogan Dawes <lists@dawes.za.net>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
Cc: Xavier Bestel <xavier.bestel@free.fr>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux kernel without file system
References: <496DA678.1090701@wpkg.org> <20090114093422.GA9771@frolo.macqel> <1231926744.11907.12.camel@skunk> <20090114101828.GA15141@frolo.macqel>
In-Reply-To: <20090114101828.GA15141@frolo.macqel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter wrote:

> Keeping thinking about it, I now think that my 'application program'
> (basically a serial-to-ethernet converter) should be a kernel thread,
> because of the small memory constraints.
> 
> The question is thus how to access the serial lines from a kernel thread.
> 
> Philippe

If your constraints are that severe, perhaps you should be investigating
other solutions. e.g. eCos?

Linux doesn't ALWAYS have to be the answer :-)

Rogan
