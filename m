Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbYAQWWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbYAQWWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYAQWWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:22:44 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:60942 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbYAQWWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:22:43 -0500
Date: Thu, 17 Jan 2008 23:22:42 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Kyle McMartin <kyle@mcmartin.ca>
cc: mingo@elte.hu, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: remove casts
In-Reply-To: <20080117064305.GB4495@phobos.i.cabal.ca>
Message-ID: <Pine.LNX.4.64.0801172321200.18447@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801162213390.31385@fbirervta.pbzchgretzou.qr>
 <20080116222055.GA344@phobos.i.cabal.ca> <Pine.LNX.4.64.0801162357160.31385@fbirervta.pbzchgretzou.qr>
 <20080117064305.GB4495@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 17 2008 01:43, Kyle McMartin wrote:
>On Wed, Jan 16, 2008 at 11:57:54PM +0100, Jan Engelhardt wrote:
>> 
>> On Jan 16 2008 17:20, Kyle McMartin wrote:
>> >On Wed, Jan 16, 2008 at 10:15:39PM +0100, Jan Engelhardt wrote:
>> >> parent a9f7faa5fd229a65747f02ab0f2d45ee35856760
>> >> commit ffffffffffffffffffffffffffffffffffffffff
>> >
>> >^- did you just make that up? ;-)
>> 
>> Yes. git does not care anyway.
>> 
>
>right. the point was if you had generated a sha1 of all ones. that would
>be kind of neat.
>
Should have used 0000.. because that is what git uses if there is
'nothing' (e.g. "from 0000.." on git-push).
I decided to nuke the commit id because the patch does not match
the one in my uploaded git tree anymore; and issuing a merge seems
like overkill for x86, so i just sent a cherry patch like this.
