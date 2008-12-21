Return-Path: <linux-kernel-owner+w=401wt.eu-S1751776AbYLUUsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbYLUUsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 15:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYLUUsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 15:48:43 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50866 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYLUUsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 15:48:43 -0500
Date: Sun, 21 Dec 2008 20:48:37 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Alessandro Bono <alessandro.bono@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problem with thermal control: ACPI: Critical trip point - Critical temperature reached  - shutting down.
Message-ID: <20081221204837.GA1684@srcf.ucam.org>
References: <gigib1$fbj$1@ger.gmane.org> <494C8B5B.8020606@shaw.ca> <1229770623.8215.82.camel@champagne.cantina> <494E862D.5030309@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494E862D.5030309@shaw.ca>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if the hardware has thermal issues, the presence of the passive 
trip point means that we should be able to manage the situation. The 
obvious question is whether the passive trippoint is being signalled by 
the hardware or not, and if it is whether we're responding aggressively 
enough.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
