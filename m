Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbYAAOgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbYAAOgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 09:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYAAOgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 09:36:40 -0500
Received: from ns2.suse.de ([195.135.220.15]:58840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbYAAOgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 09:36:40 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6.25 patch] remove a.out interpreter for ELF executables
Date: Tue, 1 Jan 2008 15:36:32 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20080101134749.GJ2360@does.not.exist>
In-Reply-To: <20080101134749.GJ2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801011536.32598.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 January 2008 14:47:49 Adrian Bunk wrote:
> This patch contains the scheduled removal of the a.out interpreter 
> support for ELF executables.

I already have a similar patch queued

ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/remove-aout-interpreter

Also removal of the old unused iBCS hooks while I was on it

ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/remove-ibcs-support

-Andi
