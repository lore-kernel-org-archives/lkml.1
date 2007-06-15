Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbXFOLTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbXFOLTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXFOLTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:19:39 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:38394 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbXFOLTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:19:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=Ejr5OxruS1WAWmjcP9odmqjOUi+zMfm7Sn1fEgYKRY6aY7sDDRq3BFxcbKlNGP4X4ps1F4DNc/jvzjuGXJpLldn6NXWR2eUnSt7UwyQS6HpswQV2/Qy5vbKplJJXPnbi;
Message-ID: <42688.simon.1181906375@5ec7c279.invalid>
In-Reply-To: <Pine.LNX.4.64.0706151101070.32724@fbirervta.pbzchgretzou.qr>
References: <e85b9d30706140437s5f3622c3rc86c75a4f845e7a3@mail.gmail.com>
    <20070614125224.GA4155@tatooine.rebelbase.local>
    <Pine.LNX.4.64.0706151101070.32724@fbirervta.pbzchgretzou.qr>
Date: Fri, 15 Jun 2007 12:19:35 +0100
Subject: Re: /dev/loop* devices not appearing in /dev (at least since 
     2.6.22-rc3*)
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Cc: "markus reichelt" <ml@mareichelt.de>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, June 15, 2007 10:01, Jan Engelhardt wrote:
>
> On Jun 14 2007 14:52, markus reichelt wrote:
>>* Matthew <jackdachef@gmail.com> wrote:
>>
>>> I read that now loop devices are being created on demand, which
>>> obviously (still) not works
>>
>>yes, someone thought this was a good idea :(
>
> It *is* a good idea. MD works that way too.

There's a patch around somewhere to create at least 8 devices, I don't know why it's not in Linus' tree yet...

-- 
Simon Arlott
