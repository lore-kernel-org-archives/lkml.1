Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbYCWWKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbYCWWKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 18:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbYCWWKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 18:10:08 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43675 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754167AbYCWWKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 18:10:07 -0400
Message-Id: <1206310206.17373.1243881033@webmail.messagingengine.com>
X-Sasl-Enc: ziBQ2K/BNd+zcYd4wJfFIPnn6rEPrY08K/Fr2z6WOwtW 1206310206
From: "Kai" <epimetreus@fastmail.fm>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Re: Serious performance regression in Wine applications and Linux
   2.6.24.*
Date: Sun, 23 Mar 2008 15:10:06 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally, it was just about everything -- Wine itself, and most any
app I tried to run with it.

In my most recent tests, however, it only seems to affect Age of Wonders
II and Age of Wonders Shadow Magic, which use very similar engines.

On Sun, 23 Mar 2008 10:44:06 +0000, "David" <david@unsolicited.net>
said:
> Kai wrote:
> > Performance degrades by about 60% when I run Wine under any of the
> > 2.6.24.* kernels. Attached are the output of lspci -vv and the two
> > config files of each kernel.
> >
> > I upgraded to 2.6.24, back to 2.6.23.(not sure), then tried 2.6.24.1 and
> > 2.6.24.3 and the issue is present in both; it's severe enough that Wine
> > apps are virtually unusable for me with this version of the kernel; I'm
> > having to use 2.6.23 until this somehow is resolved.
> >
> > I'd like some help figuring out why this performance regression exists,
> > and what can be done to mitigate it.
> >
> > Please CC replies; I'm not on the list.
> >   
> This is strange, as my (two) Windows apps ran (and run) just fine under 
> 2.6.24 (and now under 2.6.25-rc6). Could you specify the applications 
> you're having problems with?
> 
> David
