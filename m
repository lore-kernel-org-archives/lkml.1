Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbXEYX2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbXEYX2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 19:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbXEYX22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 19:28:28 -0400
Received: from terminus.zytor.com ([192.83.249.54]:52014 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbXEYX21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 19:28:27 -0400
Message-ID: <46577112.7090106@zytor.com>
Date: Fri, 25 May 2007 16:28:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ben Collins <ben.collins@ubuntu.com>, Andi Kleen <andi@firstfloor.org>,
       Ben Collins <bcollins@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] i386/x86_64: Allow disabling the putstr's from compressed
 boot wrapper
References: <98cd38b5.git.bcollins@ubuntu.com> <1180097543.12570.396.camel@cunning> <46573CE4.8080300@zytor.com> <200705251623.55551.jbarnes@virtuousgeek.org>
In-Reply-To: <200705251623.55551.jbarnes@virtuousgeek.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> 
> But how often do you have to debug bootloader or compressed boot code?  In 
> fact, most debug output like this isn't very useful after some initial 
> debugging, so we usually take it out.  I'm not sure why this would be any 
> different...
> 

You're asking me this?

I get to hear all the time about some new platform -- sometimes exotic,
sometimes not -- breaking early boot.

	-hpa
