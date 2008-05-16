Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbYEPQEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbYEPQEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYEPQEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:04:32 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:45132 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYEPQEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:04:31 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: dean <dean@sensoray.com>
Subject: Re: [PATCH] USB: add Sensoray 2255 v4l driver
Date: Fri, 16 May 2008 18:04:22 +0200
User-Agent: KMail/1.9.9
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, Greg KH <greg@kroah.com>,
       v4l-dvb-maintainer@linuxtv.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, video4linux-list@redhat.com
References: <20080514205927.GA13134@kroah.com> <200805160828.13856.oliver@neukum.org> <482DAEDB.70702@sensoray.com>
In-Reply-To: <482DAEDB.70702@sensoray.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805161804.23515.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 16 Mai 2008 17:57:15 schrieb dean:
> Hi Oliver,
> 
> Just to be clear.  You mean fixing the loading issues(ugly msleep,

Yes.
 
> etc...) that Mauro mentioned, not the YUV formats(which seem unrelated)? 
> 
> Would it be ok to have just 422P and greyscale in the driver for now if 
> we can't get a firmware update in a reasonable timeframe? It's certainly 
> not ideal, but we could direct our customers to the libraries, at least 
> until we get a proper HW fix.

I am incompetent to answer that.

	Regards
		Oliver
