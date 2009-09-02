Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbZIBNE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbZIBNE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZIBNE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:04:58 -0400
Received: from poutre.nerim.net ([62.4.16.124]:51646 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbZIBNE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:04:57 -0400
Date: Wed, 2 Sep 2009 15:04:56 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "H Hartley Sweeten" <hartleys@visionengravers.com>
Cc: <lm-sensors@lm-sensors.org>, <mactel-linux-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <alistair@devzero.co.uk>,
       <nicolas@boichat.ch>, <juergh@gmail.com>, <frank@f-seidel.de>,
       <jim.cromie@gmail.com>, <mhoffman@lightlink.com>,
       <vt8231@hiddenengine.co.uk>
Subject: Re: [PATCH] hwmon: include <linux/io.h> instead of <asm/io.h>
Message-ID: <20090902150456.6c3c0767@hyperion.delvare>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901BE9DA3@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901BE9DA3@mi8nycmail19.Mi8.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 16:56:56 -0400, H Hartley Sweeten wrote:
> Drivers should be including <linux/io.h> instead of <asm/io.h>.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Alistair John Strachan <alistair@devzero.co.uk>
> Cc: Nicolas Boichat <nicolas@boichat.ch>
> Cc: Juerg Haefliger <juergh@gmail.com>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Frank Seidel <frank@f-seidel.de>
> Cc: Jim Cromie <jim.cromie@gmail.com>
> Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
> Cc: Roger Lucas <vt8231@hiddenengine.co.uk>

Applied, thanks.

-- 
Jean Delvare
