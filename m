Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856Ab0BEVgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:36:01 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48508 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab0BEVf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:35:59 -0500
Date: Fri, 5 Feb 2010 21:35:55 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: dvomlehn@cisco.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
	writes" causes gobi_loader to hang
Message-ID: <20100205213555.GA15760@srcf.ucam.org>
References: <20100117025535.GB7045@srcf.ucam.org> <201002031821.39532.oliver@neukum.org> <20100203223737.GA2578@srcf.ucam.org> <201002032358.03552.oliver@neukum.org> <20100205195817.GA14285@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205195817.GA14285@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Full log is at http://www.codon.org.uk/~mjg59/gobi_log.gz

-- 
Matthew Garrett | mjg59@srcf.ucam.org
