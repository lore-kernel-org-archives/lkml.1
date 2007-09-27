Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbXI0MOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbXI0MOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 08:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbXI0MOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 08:14:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42686 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbXI0MOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:14:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pierre-Yves Paulus <py@idlum.be>
Subject: Re: Warnings and Bug on 2.6.23-rc6 closing rfcomm links (device_move() API ?)
Date: Thu, 27 Sep 2007 14:29:09 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       BlueZ development <bluez-devel@lists.sourceforge.net>
References: <46F92586.5070402@idlum.be>
In-Reply-To: <46F92586.5070402@idlum.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271429.09910.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 September 2007 17:13, Pierre-Yves Paulus wrote:
> Hello,
> 
> Yet another report, once again while putting rfcomm system under load. 
> Several USB adapters, several links.

Is this a regression or does it happen with 2.6.22 too?

Greetings,
Rafael
