Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbYHBKjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbYHBKjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 06:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYHBKjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 06:39:45 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:58042 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYHBKjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 06:39:44 -0400
Date: Sat, 2 Aug 2008 12:39:36 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Michael Opdenacker <michael@free-electrons.com>,
       linux-embedded@vger.kernel.org
Subject: Re: [PATCH 2/6] Container Freezer: Make refrigerator always
 available
Message-ID: <20080802123936.5f8613bd@surf>
In-Reply-To: <1217617689.25300.213.camel@localhost.localdomain>
References: <20080801050659.924495279@us.ibm.com>
	<20080801050700.528446138@us.ibm.com>
	<20080801162712.63721e8c@surf>
	<1217617689.25300.213.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Fri, 01 Aug 2008 12:08:09 -0700,
Matt Helsley <matthltc@us.ibm.com> a écrit :

> 	How about making it depend on a combination of CONFIG
> variables? Here's an RFC PATCH. Completely untested.

It solves my kernel size increase problem, so it's perfectly fine for
me.

Thanks!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
