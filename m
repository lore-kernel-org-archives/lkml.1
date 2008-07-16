Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbYGPLnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbYGPLnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 07:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbYGPLnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 07:43:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42379 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYGPLnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 07:43:04 -0400
Date: Wed, 16 Jul 2008 13:43:01 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: John Kacur <jkacur@gmail.com>
cc: Andy Whitcroft <apw@shadowen.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Make the git URL match usage
In-Reply-To: <520f0cf10807160334y7228527ev7e970b00c734778d@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0807161338290.26724@fbirervta.pbzchgretzou.qr>
References: <200807161047.21040.jkacur@gmail.com>  <20080716102104.GA7477@shadowen.org> <520f0cf10807160334y7228527ev7e970b00c734778d@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-07-16 12:34, John Kacur wrote:
>>
>> This now looses information.  Although it is obvious that this particular
>> example (after conversion) is a git repository over git protocol this falls
>> down for other forms, for example a git repository exported over http://
[...]

git over http really is no fun at the moment and one should really
use git:// whenever possible. Where it is not possible due to
tightknotted corporate firewalls, well, that's (a) their problem and
(b) they probably know already how to go around it.

If in doubt, just add a paragraph that one can exchange git://
by http://, but I would not make it that obvious to use an inferior
transfer protocol.
