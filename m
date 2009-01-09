Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbZAIMf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbZAIMf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 07:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZAIMfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 07:35:16 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52031 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbZAIMfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 07:35:15 -0500
Date: Fri, 9 Jan 2009 12:35:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: "Brian S. Julin" <bri@abrij.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] misc: Add oqo-wmi driver for model 2 OQO backlight and rfkill control
Message-ID: <20090109123506.GB31003@srcf.ucam.org>
References: <20081127190517.GA25429@srcf.ucam.org> <alpine.LFD.2.00.0811281431320.3204@localhost.localdomain> <Pine.LNX.4.64.0811282215160.17453@sheavy.abrij.org> <20081129045045.GA13866@srcf.ucam.org> <20081203195537.GB22560@srcf.ucam.org> <alpine.LFD.2.00.0901090112190.4091@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901090112190.4091@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 01:13:03AM -0500, Len Brown wrote:
> Matthew,
> this refreshed patch sits in my test tree from about a month ago.
> I guess i was expecting you to reply to the three comments on it before 
> pushing it upstream.

Ah, sorry, I didn't realise you'd picked it up. I'm still trying to find 
some time to spend with the hardware to make sure a cleaned up version 
works correctly.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
