Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbXIDIZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbXIDIZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 04:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXIDIZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 04:25:20 -0400
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:60654 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbXIDIZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 04:25:19 -0400
Date: Tue, 4 Sep 2007 09:55:40 +0200
From: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
To: Satyam Sharma <satyam@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev Mailing List <netdev@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm 2/2] 3c59x MAINTAINERS
Message-ID: <20070904075540.GA4241@newton.mathematik.tu-chemnitz.de>
References: <alpine.LFD.0.999.0709040340250.8504@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0709040351310.8504@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709040351310.8504@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.3 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 7049152d1111125d7ee45a736bd1e49d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2007 at 03:52:50AM +0530, Satyam Sharma wrote:
> Remove duplicate entry for the same driver.

This is -mm specific. Andrew did not remove the add-3c59x-maintainer
patch after pushing it to mainline. This can be fixed just by removing
the add-3c59x-maintainer patch from -mm. 

