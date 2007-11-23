Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbXKWIRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbXKWIRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 03:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbXKWIRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 03:17:01 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:63664 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbXKWIRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 03:17:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PvHP2vvYHHF6XYfZJ6t5XDFlo1DFN063TMqIDjg1vCZvRZQn72g7R4iHUiuUDrF5jLmYgUHiRfmpZloFHChTisi9x/kaFwn0bXvn8I/XOg7cJUPMH4dF9mlsCGDOI7YFmD9B9LFJEaHFP2Oxyq2cB3Qj+oE/Opb8Y85Y/RBOtyI=
Message-ID: <47468C77.9060107@gmail.com>
Date: Fri, 23 Nov 2007 09:16:55 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Marin Mitov <mitov@issp.bas.bg>
CC: niessner@jpl.nasa.gov, linux-kernel@vger.kernel.org
Subject: Re: Where is the interrupt going?
References: <1195693710.5544.240.camel@morte.jpl.nasa.gov> <20071122022004.GB9265@fattire.cabal.ca> <20071122164853.cfdplzj5o744sw40@webmail.jpl.nasa.gov> <200711230518.01401.mitov@issp.bas.bg>
In-Reply-To: <200711230518.01401.mitov@issp.bas.bg>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2007 04:18 AM, Marin Mitov wrote:
> request_irq returns EBUSY (not -EBUSY as should be)

Because he writes -status to the output.
