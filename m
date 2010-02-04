Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab0BDBkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 20:40:07 -0500
Received: from khc.piap.pl ([195.187.100.11]:45660 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933094Ab0BDBj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 20:39:56 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Joe Perches <joe@perches.com>
Cc: Mark Lord <kernel@teksavvy.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 02/10] drivers/ata: Fix continuation line formats
References: <cover.1265095093.git.joe@perches.com>
	<12d39ac4f14bfe82a02b4ee246d183b48988fe12.1265095094.git.joe@perches.com>
	<4B69B0A0.2040701@teksavvy.com>
	<1265224535.24887.16.camel@Joe-Laptop.home>
Date: Thu, 04 Feb 2010 02:39:53 +0100
In-Reply-To: <1265224535.24887.16.camel@Joe-Laptop.home> (Joe Perches's
	message of "Wed, 03 Feb 2010 11:15:35 -0800")
Message-ID: <m3pr4lye1i.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> If it's ever agreed that all lines > 80 cols are OK or
> new args after column 80 are OK, then sure.

It's been already agreed they are OK for any code.
There is no problem with complexity there, is there?
-- 
Krzysztof Halasa
