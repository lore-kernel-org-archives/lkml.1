Return-Path: <linux-kernel-owner+w=401wt.eu-S934343AbYEFXne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343AbYEFXne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762154AbYEFXnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:43:23 -0400
Received: from mjg.x.mythic-beasts.com ([93.93.128.6]:41292 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760018AbYEFXnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:43:22 -0400
Date: Wed, 7 May 2008 00:43:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dag Bakke <dag@bakke.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       "Diego 'Flameeyes' Petteno" <flameeyes@gmail.com>
Message-ID: <20080506234307.GA27714@srcf.ucam.org>
References: <4814612F.5030606@bakke.com> <20080506125406.dc047710.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506125406.dc047710.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] fix apple alu keyboard with numpad
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 12:54:06PM -0700, Andrew Morton wrote:

> > -static int hid_apple_fnmode = 1;
> > +static int hid_apple_fnmode = 2;

Regardless of anything else, we don't want this hunk.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
