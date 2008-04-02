Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYDBX4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYDBX4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 19:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756990AbYDBX4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 19:56:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55748 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbYDBX4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 19:56:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Schweizer <genstef@gentoo.org>
Subject: Re: suspend
Date: Thu, 3 Apr 2008 01:55:33 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com> <200804021939.46733.rjw@sisk.pl> <ft13p5$h64$1@ger.gmane.org>
In-Reply-To: <ft13p5$h64$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804030155.33888.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of April 2008, Stefan Schweizer wrote:
> Rafael J. Wysocki wrote:
> 
> > On Wednesday, 2 of April 2008, Justin Mattock wrote:
> >> Hello; the only problems I see after a suspend is the appletouch
> >> looses its scroll function,
> > 
> > Is that a USB device or some other kind?
> 
> I have the same Problem on my macbook 13,3" using the appletouch usb module
> to drive the touchpad. chvt 1; chvt 7 brings the touchpad back after resume
> but do you maybe know a better solution?

No, I don't, but perhaps the USB developers do (CCed now).

Thanks,
Rafael
