Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449Ab0AZXyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0AZXyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075Ab0AZXx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:53:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:59304 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab0AZXxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:53:55 -0500
Date: Wed, 27 Jan 2010 00:53:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: typo in ./crypto/Kconfig
In-Reply-To: <201001262102.15946.toralf.foerster@gmx.de>
Message-ID: <alpine.LNX.2.00.1001270053340.30977@pobox.suse.cz>
References: <201001262102.15946.toralf.foerster@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010, Toralf Förster wrote:

> Hello,
> 
> line 819 lacks an "e":
> 
> "ANSI X9.31 A.2.4. Not this option must be enabled if CRYPTO_FIPS" 
> 
> , isn't it ? 

You are right. I will fix that text up.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
