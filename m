Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbXIUIfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbXIUIfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 04:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbXIUIfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 04:35:36 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:37096 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbXIUIfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 04:35:36 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Werner Cornelius <Werner.Cornelius@cornelius-consult.de>
Subject: Re: [PATCH] Re: Serial USB-driver for Winchiphead CH340/41 chip
Date: Fri, 21 Sep 2007 10:36:15 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com
References: <200709141438.55147.Werner.Cornelius@cornelius-consult.de> <20070920000336.GA17357@kroah.com> <200709211015.11470.Werner.Cornelius@cornelius-consult.de>
In-Reply-To: <200709211015.11470.Werner.Cornelius@cornelius-consult.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211036.15941.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 21 September 2007 schrieb Werner Cornelius:
> Hello,
> 
> attached you will find the patch against the 2.6.23-rc6-mm1
> 
> Changed fetaures:
> 
> 1. All baudrates possible (dynamic baudfactor calculation)
> 2. Added support of modem control and status lines.

Cool. Could you resend with a Signed-off-by: line?

	Regards
		Oliver

