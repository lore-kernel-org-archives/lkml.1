Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab0BBVJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:09:23 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37057 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab0BBVJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:09:21 -0500
Date: Tue, 2 Feb 2010 21:09:18 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bob Rodgers <Robert_Rodgers@dell.com>
Cc: Dan Carpenter <"error27"@gmail.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       Jim Dailey <Jim_Dailey@dell.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Mario Limonciello <Mario_Limonciello@dell.com>
Subject: Re: Re: [RFC] Dell activity led WMI driver
Message-ID: <20100202210918.GA6328@srcf.ucam.org>
References: <4B6893A5.20509@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6893A5.20509@dell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me. I guess this could go through either the ACPI or LED 
maintainers, so probably best to submit it to both of them 
(lenb@kernel.org and rpurdie@rpsys.net). Feel free to add

Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
