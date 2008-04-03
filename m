Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbYDCHeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbYDCHeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760534AbYDCHe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:34:27 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:41207 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759797AbYDCHe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:34:26 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend
Date: Thu, 3 Apr 2008 09:32:27 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Stefan Schweizer <genstef@gentoo.org>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com> <ft13p5$h64$1@ger.gmane.org> <200804030155.33888.rjw@sisk.pl>
In-Reply-To: <200804030155.33888.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804030932.27993.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 3. April 2008 01:55:33 schrieb Rafael J. Wysocki:
> On Thursday, 3 of April 2008, Stefan Schweizer wrote:
> > Rafael J. Wysocki wrote:
> > 
> > > On Wednesday, 2 of April 2008, Justin Mattock wrote:
> > >> Hello; the only problems I see after a suspend is the appletouch
> > >> looses its scroll function,
> > > 
> > > Is that a USB device or some other kind?
> > 
> > I have the same Problem on my macbook 13,3" using the appletouch usb module
> > to drive the touchpad. chvt 1; chvt 7 brings the touchpad back after resume
> > but do you maybe know a better solution?
> 
> No, I don't, but perhaps the USB developers do (CCed now).

Please load the appletouch module with the parameter "debug=1" and
post dmesg of a suspend/resume and the chvt thing.

	Regards
		Oliver
