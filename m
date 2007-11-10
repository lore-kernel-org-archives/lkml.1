Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbXKJQtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbXKJQtp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 11:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbXKJQti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 11:49:38 -0500
Received: from smtp01.cdmon.com ([212.36.75.232]:55393 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbXKJQth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 11:49:37 -0500
Date: Sat, 10 Nov 2007 17:50:17 +0100
From: DervishD <lkml@dervishd.net>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Benny Halevy <bhalevy@panasas.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Coding Style: indenting with tabs vs. spaces
Message-ID: <20071110165017.GB16090@DervishD>
Mail-Followup-To: Xavier Bestel <xavier.bestel@free.fr>,
	Benny Halevy <bhalevy@panasas.com>,
	lkml <linux-kernel@vger.kernel.org>
References: <4732E6BA.8060001@panasas.com> <20071110120424.GA16067@DervishD> <1194697674.6176.1.camel@bip.parateam.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1194697674.6176.1.camel@bip.parateam.prv>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Bonjour Xavier :)

 * Xavier Bestel <xavier.bestel@free.fr> dixit:
> Le samedi 10 novembre 2007 à 13:04 +0100, DervishD a écrit :
> >  * Benny Halevy <bhalevy@panasas.com> dixit:
> > > I would like to hear peoples opinion about the indentation convention
> > > described below that I personally found the most practical with
> > > several different editors.
> > 
> > While I respect you opinion about tabs, I find tab indentation the most
> > evil thing ever invented. Even if done right (that is, not indenting
> > using a mixture of spaces and tabs), the only advantage is that you save
> > a few bytes.
> 
> Who cares ?

About the space saving? Not me, of course. It's just that I didn't see
any other advantage.

> The only advantage is that people can make tabs as big (or as small)
> as they wish. Tabs become "logical indentation". So one's indentation
> isn't forced on anotherone's editor.

The only way of having a sane indentation using tabs is to make sure
that ALL indentation are tabs, not a mix of tabs and spaces (spaces, if
any, should be at the end of indentation for aesthetical purposes, but
should be removed without the logical indentation being lost). A good
editor can ensure that all indentation are tabs and not a mix, but a
good editor can adapt indentation to your likings when loading the file
and save the file translating your favourite indentation back to spaces
or whatever.

If everybody used tabs correctly, indenting using tabs would be great,
but IMHO indenting with spaces is much better.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
We are waiting for 13 Feb 2009 23:31:30 +0000 ...
