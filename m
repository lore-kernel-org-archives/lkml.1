Return-Path: <linux-kernel-owner+w=401wt.eu-S1764682AbXGaO6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764682AbXGaO6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761721AbXGaO6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:58:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:2533 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760501AbXGaO6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:58:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BGb8Qiiha9hS/6hGgv6PvHsnw3m+IhtTENYuWa0Bq0OH+s5/xVFJuCQ2pvtwUAXIBofkzdIEht4s2duXfICHoGiuUG6W4A1wCTiw5shsbwBsKzJX8/50pQ7s1iBNjFq4qojHi9eK9gEgdO/2jImljcrCD1rgiPPswNHoWvX0ucg=
Message-ID: <46AF4E12.8060204@gmail.com>
Date: Tue, 31 Jul 2007 23:58:26 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jeff Garzik <jeff@garzik.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
References: <20070705194909.337398431@intel.com>	 <20070705130518.135e4e3c.kristen.c.accardi@intel.com>	 <46AE12B6.6090408@garzik.org>  <46AED656.8070407@gmail.com> <1185891382.2750.8.camel@laptopd505.fenrus.org>
In-Reply-To: <1185891382.2750.8.camel@laptopd505.fenrus.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> either sucks. AHCI ALPM ought to work if it's supported; it's what other
> operating systems also use... 

A question.  Does the other OS enable ALPM without checking against
white/black list?  Or is it enabled only on certain configurations -
e.g. specific notebooks, etc?

-- 
tejun
