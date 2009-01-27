Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbZA0PR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbZA0PR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZA0PRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:17:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33547 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbZA0PRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:17:49 -0500
Subject: Re: [RT] [RFC] simple SMI detector
From: Jon Masters <jcm@redhat.com>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
In-Reply-To: <20090127112222.GB21011@elf.ucw.cz>
References: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org>
	 <20090127112222.GB21011@elf.ucw.cz>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Tue, 27 Jan 2009 10:17:44 -0500
Message-Id: <1233069464.3797.0.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 12:22 +0100, Pavel Machek wrote:

> Please use Kconfig here.

Oops. I didn't notice that...someone else did the build and config bits
after I posted the module. Thanks, I'll get that fixed and repost!

Jon.


