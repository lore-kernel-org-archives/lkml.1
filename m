Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbYAGRkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbYAGRkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYAGRjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:39:55 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:55104 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbYAGRjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:39:55 -0500
Date: Mon, 7 Jan 2008 18:39:53 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Michal Simek <simekm2@fel.cvut.cz>,
       linux-kernel@vger.kernel.org, monstr@monstr.eu
Subject: Re: New linux arch
In-Reply-To: <478260C9.6040407@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0801071838340.14194@fbirervta.pbzchgretzou.qr>
References: <47820D24.3060800@fel.cvut.cz> <84144f020801070447t68808bcdq64bfc949c7732462@mail.gmail.com>
 <Pine.LNX.4.64.0801071433510.14194@fbirervta.pbzchgretzou.qr>
 <478260C9.6040407@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 7 2008 18:26, Stefan Richter wrote:
>Jan Engelhardt wrote:
>>>On Jan 7, 2008 1:29 PM, Michal Simek <simekm2@fel.cvut.cz> wrote:
>>>> Is it possible to create git repository in git.kernel.org for Microblaze
>>>> cpu?
>...
>> Alternatively, providing your own git service is just as effective,
>> and comes with much more freedom :)
>
>It is /almost/ as effective:
>  - Many of the git trees on kernel.org are set up to share objects with
>Linus' tree.

Oh? So `du -s davem/net-2.6.25` will not be like 170 megs in size?

>  - The tree owners can fetch from each other locally and via ssh:
>protocol, alternatively to the remote protocols.

For bandwidth-savers, yeah. For those who have the pipe, time, money 
or devotion, pulling from torvalds/linux-2.6.git is enough, and it will be
pushed out with the next set of development changesets anyway :-)
