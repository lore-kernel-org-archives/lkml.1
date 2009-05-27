Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbZE0QHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbZE0QHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 12:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbZE0QHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 12:07:45 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2705 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZE0QHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 12:07:45 -0400
Subject: Re: Lkml dropping mail?
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: bobby.prani@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090527.031849.245052029.davem@davemloft.net>
References: <430c80e90905270044t4f2baa0u3e3c35b96f4a13df@mail.gmail.com>
	 <20090527.031849.245052029.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 27 May 2009 09:07:42 -0700
Message-Id: <1243440462.27337.14.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 03:18 -0700, David Miller wrote:
> From: Pranith Kumar <bobby.prani@gmail.com>
> Date: Wed, 27 May 2009 13:14:18 +0530
> 
> > Lkml missed two mails I sent earlier. Is it dropping the mail or something?
> 
> If you have syntax errors in your email headers or some similar
> problem with the content, we drop the message on the floor
> and I personally get a bounce message indicating this.
> 
> We don't automate sending the notification to the sender
> because most of the things triggering this are SPAM.

I think one more type of mail that would be good to
automatically drop would be any mail that bcc's a list.

ie: if no list entry in the to: or cc: header, drop.


