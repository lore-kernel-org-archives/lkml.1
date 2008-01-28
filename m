Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYA1SYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYA1SYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbYA1SXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:23:51 -0500
Received: from pyxis.services.brown.edu ([128.148.106.154]:53456 "EHLO
	pyxis.services.brown.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYA1SXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:23:50 -0500
Message-ID: <479E1D9E.3000900@bobjweil.com>
Date: Mon, 28 Jan 2008 13:23:26 -0500
From: Richard Heck <rgheck@bobjweil.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Daniel Barkalow <barkalow@iabervon.org>
CC: Gene Heskett <gene.heskett@gmail.com>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
References: <200801272122.21823.gene.heskett@gmail.com> <1201539043.31293.7.camel@zem> <1201540830.6526.19.camel@localhost> <200801281230.32910.gene.heskett@gmail.com> <alpine.LNX.1.00.0801281248190.13593@iabervon.org>
In-Reply-To: <alpine.LNX.1.00.0801281248190.13593@iabervon.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Brown-Proofpoint: Not Infected
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 classifier= adjust=0 reason=safe engine=3.1.0-0708230000 definitions=main-0801280072
X-Brown-MailScanner-SpamCheck: not spam, rule=notspam policy=default score=0 classifier= adjust=0 reason=safe engine=3.1.0-0708230000 definitions=main-0801280072
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Barkalow wrote:
> Can you switch back to old IDE to get your work done (and to make sure 
> it's not a hardware issue that's developed recently)? 
I think it'd be really, REALLY helpful to a lot of people if you, or 
someone, could explain in moderate detail how this might be done. I 
tried doing it myself, but I'm not sufficiently expert at configuring 
kernels that I was ever able to figure out how to do it.

Obviously, the short version is: switch back to Fedora 6. But this kind 
of problem with libata---and yes, you're almost surely right that it's 
not one problem but lots---is sufficiently widespread that a Mini HOWTO, 
say, would be really welcome and, I'm guessing, widely used.

Richard

