Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZGRRDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZGRRDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 13:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZGRRDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 13:03:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52340 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbZGRRDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 13:03:35 -0400
Date: Sat, 18 Jul 2009 18:03:32 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Frans Pop <elendil@planet.nl>, Larry Finger <Larry.Finger@lwfinger.net>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT] hp-wmi: improved rfkill support for wifi
Message-ID: <20090718170332.GA30201@srcf.ucam.org>
References: <4A61FE7D.9080409@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A61FE7D.9080409@tuffmail.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 05:55:25PM +0100, Alan Jenkins wrote:
> I borrowed a HP G7000 last week.  The hp-wmi driver seemed a bit
> confused about hard v.s. soft blocks on the wifi, so I fixed it based on
> acpidump output [1].  I hope this will work on other HP model numbers,
> but it would benefit from testing.  Any volunteers?

This looks good. Would you mind doing the same for bluetooth and wwan? 
What documentation I have suggests they should have the same behaviour.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
