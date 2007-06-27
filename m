Return-Path: <linux-kernel-owner+w=401wt.eu-S1762643AbXF0SwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762643AbXF0SwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757662AbXF0SwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:52:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44204 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbXF0SwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:52:03 -0400
Subject: Re: Linux Kernel include files
From: Arjan van de Ven <arjan@infradead.org>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: bunk@stusta.de, schilling@fokus.fraunhofer.de, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4682932d.pVHCxteMR+otOnHO%Joerg.Schilling@fokus.fraunhofer.de>
References: <46826d13.44vmeDzVCWEJhtNJ%Joerg.Schilling@fokus.fraunhofer.de>
	 <20070627164012.GQ1094@stusta.de>
	 <4682932d.pVHCxteMR+otOnHO%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 27 Jun 2007 11:50:40 -0700
Message-Id: <1182970240.2718.6.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 18:41 +0200, Joerg Schilling wrote:

> Well, I did report these kind of problems many years ago and as it has not been 
> fixed after some years, I was asuming that it is still the way I see it on Suse 
> 10.0.

I'd suggest reporting SuSE bugs to SuSE; that's more effective ;)
(although I don't know how they will deal with bugreports against older
versions)

your bug looks certainly valid.. just you're not using the "proper"
header set that the kernel developers suggest ;)


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

