Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbXLZUIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbXLZUIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 15:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbXLZUIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 15:08:11 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:57738 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbXLZUIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 15:08:11 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] sleepy linux
Date: Wed, 26 Dec 2007 21:08:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20071225230731.GA29030@elf.ucw.cz> <4772A3FB.8080108@zytor.com>
In-Reply-To: <4772A3FB.8080108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712262108.35643.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 26. Dezember 2007 19:56:59 schrieb H. Peter Anvin:
> > 3) Network card that is either down
> >    or can wake up system on any packet (and not loose too many packets)
> > 
> 
> This is the big crux I see.  You're going to constantly wake up the 
> machine due to broadcast packets, and spend a lot of power just going in 
> and out of S3.

How many machines care a lot about saving power while they are connected
to an ethernet? Wlan might be more of a problem.

	Regards
		Oliver

