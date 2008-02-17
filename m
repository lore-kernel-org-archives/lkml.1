Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYBQSGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYBQSGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYBQSGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:06:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38706 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbYBQSGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:06:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [2.6.25-rc2] stack trace immediately before rebooting/switching off
Date: Sun, 17 Feb 2008 19:04:54 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <200802171516.57468.arvidjaar@mail.ru>
In-Reply-To: <200802171516.57468.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802171904.54609.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of February 2008, Andrey Borzenkov wrote:
> In 2.6.25 I get stack trace immediately before system is switched off or
> reboots. It is too fast to capture it on VGA; netconsole does not capture
> it either - probably network is already shutdown at this point. I do
> not have serial port on this system.
> 
> Any idea how could I capture it? Thank you.
> 
> The problem did not exist in 2.6.24 and below. 

Is this the e100 issue you reported later or something else?

Rafael
