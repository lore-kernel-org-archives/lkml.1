Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbYEDT4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbYEDT4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbYEDT42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:56:28 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37775 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbYEDT41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:56:27 -0400
Date: Sun, 4 May 2008 21:56:26 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: =?UTF-8?Q?Malte_Schr=C3=B6der?= <maltesch@gmx.de>
cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Hard lockup with kernel 2.6.25 and 2.6.25.1
In-Reply-To: <20080504115108.7b5a8e3f@highlander.home.lan>
Message-ID: <alpine.LNX.1.10.0805042155530.11757@fbirervta.pbzchgretzou.qr>
References: <20080504005209.13af2b2c@highlander.home.lan> <20080503231813.GA18248@kroah.com> <20080504115108.7b5a8e3f@highlander.home.lan>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2008-05-04 11:51, Malte Schröder wrote:
>> 
>> If it's repeatable, it would be interesting if you are able to do a
>> git-bisect to try to narrow the issue down...
>
>Hmm, that's about the only box of mine where bisecting a kernel really
>hurts. It's my central VoIP, internet, mail and other stuff gateway and
>it takes ages to boot (it's the box where my old hardware ends up).

You can compile the tree elsewhere (without nfs) and then run the
appropriate install mechanisms with an NFS mount.

