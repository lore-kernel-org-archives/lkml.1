Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378Ab0AMNSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0AMNSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:18:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381Ab0AMNSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:18:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51478 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752618Ab0AMNSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:18:09 -0500
Date: Wed, 13 Jan 2010 13:18:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       "Quadros Roger (Nokia-D/Helsinki)" <roger.quadros@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: Add 'start-up time' to fixed voltage
 regulators
Message-ID: <20100113131806.GE27473@rakim.wolfsonmicro.main>
References: <4B4DB562.2080601@nokia.com>
 <20100113120327.GB27473@rakim.wolfsonmicro.main>
 <4B4DB94E.8080602@nokia.com>
 <20100113122612.GC27473@rakim.wolfsonmicro.main>
 <4B4DC2A7.5030108@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4DC2A7.5030108@nokia.com>
X-Cookie: Kiss me twice.  I'm schizophrenic.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 02:55:03PM +0200, Adrian Hunter wrote:
> Mark Brown wrote:

> >IIRC ie, a one character indent on the context as well as the changed
> >lines.

> I meant that the space is, in fact, there.
> e.g. see http://lkml.org/lkml/2010/1/13/186

I see what the problem is here, you're sending in format=flowed which
means that MUAs that understand format=flowed will reindent the text on
reciept.  The indentation of the original mail will be ignored.
