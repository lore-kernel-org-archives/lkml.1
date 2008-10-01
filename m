Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYJASeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYJASeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYJASd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:33:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44466 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbYJASd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:33:58 -0400
Date: Wed, 1 Oct 2008 19:33:50 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Pavel Machek <pavel@suse.cz>, carbonated beverage <ramune@net-ronin.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Thinkpad brightness keys kill X on 2.6.26.5
Message-ID: <20081001183350.GA3240@srcf.ucam.org>
References: <20080925060244.GA18945@net-ronin.org> <20080930231952.GB15903@ucw.cz> <48E2CB5A.1050809@goop.org> <20081001095322.GA27987@srcf.ucam.org> <48E3C152.1000102@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E3C152.1000102@goop.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 11:28:34AM -0700, Jeremy Fitzhardinge wrote:

> I'm also using the vesa X server; I haven't tried using the intel one yet.

Ah. In that case, I suspect the DRM module is never binding and may not 
do its thing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
