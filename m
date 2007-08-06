Return-Path: <linux-kernel-owner+w=401wt.eu-S1764999AbXHFMe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764999AbXHFMe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 08:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764275AbXHFMec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 08:34:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:40499 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763584AbXHFMeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 08:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ln15NOfe9T+P9fMo5WizNjZ9/UONJ43Uwd70PYj+ccb/10s61tTTbUle+P50jad5B1EUcXCNVHNArvZV6F48XSIpNfa7pN2w0ZjdVNAckUzDGHdBIVe/Actdkj9KZE0I/qwsgcYP/9rDUzk6lyZ/Nj6uMrHUduo5yeFNqwp6zGg=
Subject: Re: Disk spin down issue on shut down/suspend to disk
From: Michael Sedkowski <sedmich@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 06 Aug 2007 14:34:18 +0200
Message-Id: <1186403658.5397.12.camel@nx6310>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some additional info:
As I stated before I'm using a patched sysvinit package with patch from
Debian bug 426224 with provide a patched hddown.c.
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=426224


Michael

