Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYC1TWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYC1TWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYC1TWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:22:07 -0400
Received: from vena.lwn.net ([206.168.112.25]:53625 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbYC1TWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:22:06 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [Pull] Some documentation patches 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Fri, 28 Mar 2008 20:09:39 BST."
             <alpine.LNX.1.10.0803282005440.27567@fbirervta.pbzchgretzou.qr> 
Date: Fri, 28 Mar 2008 13:22:05 -0600
Message-ID: <18643.1206732125@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> wrote:

> patch on top:
> 
>  - add const qualifiers
>  - remove void* casts
>  - use proper specifier (%Ld is not valid)

Looks good, I applied it.

Thanks,

jon
