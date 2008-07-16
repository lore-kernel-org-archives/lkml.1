Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbYGPXwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbYGPXwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbYGPXvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:51:53 -0400
Received: from outbound-mail-35.bluehost.com ([69.89.18.155]:51825 "HELO
	outbound-mail-35.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753307AbYGPXvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:51:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=GodQF0O1thDJ0a27aIRUt7Pqwe5DZO920axI8cmPPRTpN5mFrEuakHrqzS9eft+bSmsOWZyKlcoapxorPUIDNTSKmeU5OvdduIDxcDcePq55TD1DXlmP1hTFRzfTpvAT;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please pull ACPI updates
Date: Wed, 16 Jul 2008 16:51:44 -0700
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20080716214516.GA10777@basil.nowhere.org> <200807161633.01375.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0807161639090.2835@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807161639090.2835@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161651.44990.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2008 4:45 pm Linus Torvalds wrote:
> On Wed, 16 Jul 2008, Jesse Barnes wrote:
> > Yeah, they're interdependent (I pulled from Len's tree, hopefully Andi
> > preserved the changesets).
>
> Andi did not. The whole series I pulled was rebased today at 2PM.

Ugg, when Andi took over we talked about it; I thought we had agreed that he 
would stick with Len's tree.  I guess I was wrong.

> I was going to complain about it, because Len's trees were always a
> pleasure to pull with clearly delineated topic branches etc, and pulling
> from Andi was such a let-down in comparison.

Is a topic branch flow like what Len uses documented somewhere that you know 
of?  I know my process could use some improvement; I'd rather not have to 
wait for Len to come back to ask him. :)

Thanks,
Jesse
