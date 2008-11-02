Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYKBJVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYKBJVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 04:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYKBJVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 04:21:11 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37246 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbYKBJVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 04:21:10 -0500
Date: Sun, 2 Nov 2008 09:21:04 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4 and 5
Message-ID: <20081102092104.GC10983@srcf.ucam.org>
References: <490B3BB5.8060801@tuffmail.co.uk> <20081031171126.GA17313@srcf.ucam.org> <20081102034620.GA29606@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081102034620.GA29606@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2008 at 01:46:20AM -0200, Henrique de Moraes Holschuh wrote:

> When you don't use rfkill_set_default().  Which, if you are a platform
> driver, and your platform can store state across power off, you should use.

Ah, missed that. Yes, I'll fix that up.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
