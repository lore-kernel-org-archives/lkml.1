Return-Path: <linux-kernel-owner+w=401wt.eu-S1760894AbZD0Use@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbZD0Use (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760709AbZD0UsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:48:02 -0400
Received: from netrider.rowland.org ([192.131.102.5]:47334 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760132AbZD0UsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:48:00 -0400
Date: Mon, 27 Apr 2009 16:48:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kay Sievers <kay.sievers@vrfy.org>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: usbutils 0.81 release
In-Reply-To: <20090427193532.GA2948@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0904271645380.15670-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Greg KH wrote:

> Kay Sievers (11):
>       rename configure.in -> configure.ac
>       delete spec file

Why delete the spec file?  Don't you want to keep it for people who 
would like to build an RPM?

Alan Stern

