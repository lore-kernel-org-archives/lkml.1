Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301Ab0ANBld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0ANBld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 20:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993Ab0ANBlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 20:41:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58097
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab0ANBlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 20:41:31 -0500
Date: Wed, 13 Jan 2010 17:41:41 -0800 (PST)
Message-Id: <20100113.174141.169192840.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: netdev: patchwork.ozlabs.org vs patchwork.kernel.org ?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1263433237.1966.37.camel@Joe-Laptop.home>
References: <3DBBD805E3BA064A87F551C0E8BD36740289748A@MAILSRV.intcomgrp.com>
	<20100113.173253.223656114.davem@davemloft.net>
	<1263433237.1966.37.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 13 Jan 2010 17:40:37 -0800

> On Wed, 2010-01-13 at 17:32 -0800, David Miller wrote:
>> Encoding your patches as base64 binary octet stream attachments
>> causes them to get missed by our automated patch tracking system:
>> 
>> 	http://patchwork.ozlabs.org/project/netdev/list/
> 
> What is the reason why netdev doesn't use patchwork.kernel.org?
> 
> It seems odd that it doesn't.  Odd like the arm mailing lists.

ozlabs was the original, and so just like powerpc port that's where we
started using the tool.

I honestly don't care where it's hosted.
