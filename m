Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbZCLThl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbZCLThl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 15:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbZCLThc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 15:37:32 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:42964 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZCLThc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 15:37:32 -0400
Message-ID: <49B96471.8070602@davidnewall.com>
Date: Fri, 13 Mar 2009 06:07:21 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: I just got got another Oops
References: <200903120133.11583.gene.heskett@gmail.com> <49B8C98D.3020309@davidnewall.com> <200903121348.43477.gene.heskett@gmail.com>
In-Reply-To: <200903121348.43477.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Rebooted to the above now, still scratching head though.  Specifically, 
> setroubleshoot will not return anything but a null for any 'service' command.  
> In fact, none of the selinux stuff is running ANAICT.  Did we break other 
> stuff?
>   

It's more that we haven't fixed anything, yet, just tested an
hypothesis.  Except that looking deeply, I now see that that hypothesis
can't be right.  So this is the point that I ask you to post your
.config and perhaps also as disassembly (objump -d) of mm/pagealloc.o

Sorry to send you off on a wild goose chase.
