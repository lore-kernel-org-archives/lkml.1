Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYGUVkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYGUVkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYGUVkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:40:10 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37618 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYGUVkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:40:08 -0400
Subject: Re: [PATCH] VT: Restore VT fonts on switch
From: Ben Collins <ben.collins@canonical.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080721142315.4076c292@infradead.org>
References: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org>
	 <20080721134327.3ffab96f@infradead.org> <1216673584.7585.189.camel@cunning>
	 <20080721142315.4076c292@infradead.org>
Content-Type: text/plain
Organization: Canonical
Date: Mon, 21 Jul 2008 17:40:09 -0400
Message-Id: <1216676409.7585.215.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 14:23 -0700, Arjan van de Ven wrote:
> On Mon, 21 Jul 2008 16:53:04 -0400
> Ben Collins <bcollins@swissdisk.com> wrote:
> 
> > On Mon, 2008-07-21 at 13:43 -0700, Arjan van de Ven wrote:
> > > On Mon, 21 Jul 2008 15:39:44 -0400
> > > Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > 
> > > > Not all X drivers save and restore fonts on text VTs. Add code to
> > > > the kernel to explicitly save and restore them on VT switches.
> > > 
> > > 
> > > do you have a list of which ones don't ?
> > 
> > I don't, but perhaps Matthew does.
> > 
> I was assuming Matthew would respond since he sent this patch to lkml
> after all...

Actually, I sent it on Matthews behalf, so perhaps you could understand
why I answered.

