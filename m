Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbXDDU76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbXDDU76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbXDDU76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:59:58 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:33079 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751448AbXDDU75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:59:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dlakjfNvinn+daEnyuRUf3dLjuf4Nnwv5mS8M48ILD4BOPIYaFGtd5fLDaf4XYobML+PFSp19Iu7gv47iiEReFZNAeMFfv0Ux0nGAYRKhPd2o0qZ2REX8aqz0Fi2ZWSswpjBiznLMGmNqMCDFlvCtRz0+g6JP+59vyy1BjfHe3M=  ;
X-YMail-OSG: UyxtNBYVM1nBUrItCPuLGBCDpRhGJwhnaL_70sExzLimcBBQNrfVoOuwKLCV1PT7bx2mimkdLQ--
From: David Brownell <david-b@pacbell.net>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
Date: Wed, 4 Apr 2007 13:59:54 -0700
User-Agent: KMail/1.7.1
Cc: "Tony Lindgren" <tony@atomide.com>, linux-kernel@vger.kernel.org,
       "David Brownell" <dbrownell@users.sourceforge.net>
References: <11757099691323-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <d120d5000704041347n3abec51cxa5859a0a191b38eb@mail.gmail.com>
In-Reply-To: <d120d5000704041347n3abec51cxa5859a0a191b38eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704041359.54533.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007 1:47 pm, Dmitry Torokhov wrote:
 
> Do we need that in mainline? Why would you not use led subsystem?

There are two LED subsystems, the new/generic one and the original ARM one.

No matter which one you meant, the answer is that it's already using it.  ;)
