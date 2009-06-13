Return-Path: <linux-kernel-owner+w=401wt.eu-S1751689AbZFMEXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbZFMEXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 00:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbZFMEXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 00:23:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:45244 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZFMEXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 00:23:40 -0400
Date: Fri, 12 Jun 2009 21:24:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: IO latency - a special case
Message-ID: <20090612212414.1ae5a284@infradead.org>
In-Reply-To: <9b1675090906122048o35698c09x13cc7cf7650ac9ae@mail.gmail.com>
References: <9b1675090904041103v477913a5of06fa5c10ebee05f@mail.gmail.com>
	<9b1675090904041131u28635d8dnc3d13e88000394b4@mail.gmail.com>
	<20090405011355.GE7553@mit.edu>
	<9b1675090904042117k77463227y66a872d52d027e7e@mail.gmail.com>
	<9b1675090904042125g708076e6v665f5ecc7fa020a4@mail.gmail.com>
	<9b1675090904042313rb8178b6v1da3aeddfa57a869@mail.gmail.com>
	<20090405062626.GA7760@mit.edu>
	<9b1675090904051542o42a0ca11y1ce3b691ed6d8ebb@mail.gmail.com>
	<9b1675090906062014h2ce44d8apc50f73aa036d9139@mail.gmail.com>
	<20090611191152.GD16787@mit.edu>
	<9b1675090906122048o35698c09x13cc7cf7650ac9ae@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 21:48:41 -0600
"Trenton D. Adams" <trenton.d.adams@gmail.com> wrote:

> Sorry I didn't reply earlier.  I got busy with some server troubles
> and such.
> > What sort of process where you typicalling trying to kill using ^C?
> 
> It's maven, which spawns javac (java compiler), as well as does
> various other tasks such as making connections to the Internet, local
> directories, etc.

I assume you know latencytop and how it might be useful to diagnose
such delays ?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
