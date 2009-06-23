Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbZFWV04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbZFWV04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZFWV0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:26:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46712 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754467AbZFWV0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:26:48 -0400
Date: Tue, 23 Jun 2009 22:23:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>, sfi-devel@simplefirmware.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial
 support
Message-ID: <20090623222319.5f44332a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090623204524.GA15891@srcf.ucam.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
	<20090623183153.GB12814@srcf.ucam.org>
	<alpine.LFD.2.00.0906231438190.23079@localhost.localdomain>
	<20090623185120.GA13824@srcf.ucam.org>
	<alpine.LFD.2.00.0906231541400.23079@localhost.localdomain>
	<20090623202302.GA15265@srcf.ucam.org>
	<20090623204524.GA15891@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> not enthusiastic about seeing this presented as a fait accompli in 
> generic driver code, rather than under arch/x86/moorestown.

Certainly wouldn't be a real problem if it started there and migrated
if/when it proves to be more generic.

Alan
