Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbYGGOmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbYGGOmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYGGOlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:41:55 -0400
Received: from mail.ccur.com ([12.192.68.12]:25171 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbYGGOlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:41:55 -0400
Message-ID: <48722B31.6070209@ccur.com>
Date: Mon, 7 Jul 2008 10:41:53 -0400
From: John Blackwood <john.blackwood@ccur.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Joe Korty <joe.korty@ccur.com>
Subject: Re: [bug ?] do_get_mempolicy()
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Subject: Re: [bug ?] do_get_mempolicy()
 > From: David Rientjes <rientjes@google.com>
 > Date: Mon, 7 Jul 2008 03:05:28 -0400
 > To: "Blackwood, John" <john.blackwood@ccur.com>
 > CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
Lee Schermerhorn <lee.schermerhorn@hp.com>, "Korty, Joe" 
<joe.korty@ccur.com>
 >
 > On Thu, 3 Jul 2008, David Rientjes wrote:
 >
 > > > You're right, the flags member of struct mempolicy has subsequently
 > > > changed to carry "internal" flags that are not supposed to be 
exposed to
 > > > userspace via the get_mempolicy() API.
 > > >
 >
 > John, please give 2.6.26-rc9 a try and let me know if there's any
 > outstanding issues.

Hi David,

get_mempolicy()/do_get_mempolicy() is working fine for me now.

Thanks for your help and quick response.

