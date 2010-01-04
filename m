Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944Ab0ADBRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab0ADBRi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 20:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592Ab0ADBRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 20:17:36 -0500
Received: from khc.piap.pl ([195.187.100.11]:43474 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab0ADBRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 20:17:35 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: gentoo-user@lists.gentoo.org, Dirk Heinrichs <dirk.heinrichs@online.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [gentoo-user] RAM installed vs reported
References: <4B3B3043.20400@asyr.hopto.org>
	<200912301208.54359.dirk.heinrichs@online.de>
	<4B3B38F2.6090006@asyr.hopto.org>
	<m3fx6r8a0l.fsf@intrepid.localdomain>
	<4B3CF04E.8070603@asyr.hopto.org>
	<m3vdfmosha.fsf@intrepid.localdomain>
	<4B406CDF.7010301@asyr.hopto.org>
	<m3aawulr8t.fsf@intrepid.localdomain>
	<4B4138AB.3060602@asyr.hopto.org>
Date: Mon, 04 Jan 2010 02:17:32 +0100
In-Reply-To: <4B4138AB.3060602@asyr.hopto.org> (thanasis@asyr.hopto.org's
	message of "Mon, 04 Jan 2010 02:39:07 +0200")
Message-ID: <m3wrzyk6s3.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis <thanasis@asyr.hopto.org> writes:

> Do you mean that I should try it? Is there any gain over using
> CONFIG_HIGHMEM4G ?

You may want to try, HIGHMEM4G is (may be) slower, depending on load.
Google should find something about that.
-- 
Krzysztof Halasa
