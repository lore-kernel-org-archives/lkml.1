Return-Path: <linux-kernel-owner+w=401wt.eu-S935689AbXEWRNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935689AbXEWRNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760247AbXEWRNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:13:36 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34390 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760259AbXEWRNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:13:34 -0400
X-Sasl-enc: ye9i0qGmwdCtJaelevsN9BYyk0PcVqfTqrI2Y+tFD8i/ 1179940413
Date: Wed, 23 May 2007 14:13:30 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: 2.6.21-mm2: ACPI exception on resume
Message-ID: <20070523171330.GB9987@khazad-dum.debian.net>
References: <20070519165738.GK11115@waste.org> <20070523001943.GA3743@khazad-dum.debian.net> <20070523014825.GX11115@waste.org> <200705231057.48320.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705231057.48320.rjw@sisk.pl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Rafael J. Wysocki wrote:
> While I agree with that, it would really be helpful if you tested the latest -rc
> kernel and saw if the bug was present in there.
> 
> If the bug is not present in the latest -rc, it'll be possible to identify the
> patch that causes it to appear in -mm and find the reason of the breakage.

And, once we know the reason, we will be able to find out how to best fix the
problem.

So, do please test latest -rc, or bissect to the last known-good kernel. As
I said, we need further data points to do anything.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
