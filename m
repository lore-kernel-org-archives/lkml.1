Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbXD0Q4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbXD0Q4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbXD0Q4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:56:03 -0400
Received: from web36709.mail.mud.yahoo.com ([209.191.85.43]:41036 "HELO
	web36709.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756082AbXD0Qzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:55:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=fW7iXLMpLt1buuq9sdlRpSTQxOyjI5A9/JjWrFpyJq1Bw1TWITB6BgQ8a5ExjBzRpQKqpoGTP5WXN9e6Q9BDVIVLwC3CPoMcaQy66h/izahdxvC6hNzbBitzuvQNEh6EiSNZdYG8Zb/okz9k3NqRZ+e4zoT+qbAt48i4EAelKmc=  ;
Message-ID: <20070427165544.99355.qmail@web36709.mail.mud.yahoo.com>
X-YMail-OSG: tJUi8hAVM1mhTBtRxDrp4fMa7UreTkOBKFyOidrCdGCgQ9xbQyxvEd.K9V3UKRZjKtkA00kwndJ8.4_H.NqLwiWkpXBdI4AM.2oz
Date: Fri, 27 Apr 2007 09:55:44 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
To: Sergey Yanovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4631E93A.1010404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It seems a bit out-of-date. Here is the output:
> 
It clearly says there that the driver is for 2.6.20. The changes needed for 2.6.21 are actually
very small (couple of fields in the mmc layer were renamed).

In general, it is impossible to maintain out-of-tree driver in sync with kernel tree - too many
changes are committed into it. The -mm version obviously fits its tree.


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
