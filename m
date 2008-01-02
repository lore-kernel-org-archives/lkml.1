Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbYABA2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYABA2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 19:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbYABA23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 19:28:29 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:59555 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbYABA22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 19:28:28 -0500
X-Auth-Info: 7p8vrUi+Mf++R115OZaYUKUCoQw8h+PdcfRVsAYMciQ=
X-Auth-Info: 7p8vrUi+Mf++R115OZaYUKUCoQw8h+PdcfRVsAYMciQ=
X-Auth-Info: 7p8vrUi+Mf++R115OZaYUKUCoQw8h+PdcfRVsAYMciQ=
X-Auth-Info: 7p8vrUi+Mf++R115OZaYUKUCoQw8h+PdcfRVsAYMciQ=
X-Auth-Info: 4F42JB2/exUQjtTQw2/0YI0xwvCfRb3WDoM+Z4onZvU=
To: Adrian Bunk <bunk@kernel.org>
cc: David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [2.6 patch] remove broken MTD drivers
Mime-version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: Your message of "Wed, 02 Jan 2008 01:11:40 +0200."
             <20080101231140.GF27566@does.not.exist>
Date: Wed, 02 Jan 2008 01:28:26 +0100
Message-Id: <20080102002826.574C324889@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080101231140.GF27566@does.not.exist> you wrote:
>
> The header of ppchameleonevb.c claims it comes from info@wawnet.biz 

Argh. That's indeed ancient code.

So what should I do to fix this? Wait for Thomas' response, or port
patches here?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
A Chairman was as necessary to a Board planet  as  the  zero  was  in
mathematics, but being a zero had big disadvantages...
                         - Terry Pratchett, _The Dark Side of the Sun_
