Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbYHTU7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbYHTU7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYHTU6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:58:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33371 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbYHTU6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:58:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: 2.6.27-rc2 USB suspend regression
Date: Wed, 20 Aug 2008 23:02:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <48AC8337.2070502@goop.org>
In-Reply-To: <48AC8337.2070502@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808202302.02065.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of August 2008, Jeremy Fitzhardinge wrote:
> Using the Fedora Rawhide kernel RPM "2.6.27-0.238.rc2.fc10.i686"
> (kernel-2.6.27-0.238.rc2.fc10.i686), I'm seeing suspend to ram
> failures.  The suspend seems to go OK, but then I just get endless:
> 
> usb 5-1: uhci_result_common: failed with status 440000
> 
> messages, with occasional flickers of something else being printed
> (perhaps).  The machine is otherwise unresponsive.

I haven't seen anything like this so far with 2.6.27-rc.  No idea what might
have caused that to happen.

Thanks,
Rafael
