Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbYDUPoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbYDUPoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbYDUPoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:44:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:26724 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbYDUPog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kVQPBck9SA2YdEChgKe73vAJxO9PnEmdUsY1yNnm3CjZtrHZ/JqNy00Nc3/GOw212M1LRyEl4kK73mgO1jzXcx2jktDvhSoMC1Sy4GIi4Z+VNe/MbZ+jTNPFnDQSexyme1CvuzCPZo+GYq01lkZk4vf6ZNps4Xnqp8MNLYMitww=
Date: Mon, 21 Apr 2008 11:44:29 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/37] Input queue for 2.6.26 merge window
Message-ID: <20080421154429.GC6884@anvil.corenet.prv>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com> <20080421151107.GC18932@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421151107.GC18932@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrique,

On Mon, Apr 21, 2008 at 12:11:07PM -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 21 Apr 2008, Dmitry Torokhov wrote:
> > The following patches are what I would like to get in 2.6.26
> > in the next couple of days. Please shout if you see any problems.
> 
> Dmitry,
> 
> What about the second version of the SW_RADIO event rename patch (which
> keeps the old name like you asked)?  You didn't either ACK or NACK that
> one...
> 

Ah, sorry. I am not very fond of having multiple aliases, but if you
think that the new name will help to avoid confusion in the future I am
OK with it. You may add:

	Acked-by: Dmitry Torokhov <dtor@mail.ru>

I expect it to go through rfkill/net tree with the rest of rfkill
changes.

-- 
Dmitry
