Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbZASVj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbZASVj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZASVjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:39:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39773 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbZASVjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:39:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: Another libata error related to OCZ SSD
Date: Mon, 19 Jan 2009 22:39:24 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <20090111174159.GC4250@ics.muni.cz>
In-Reply-To: <20090111174159.GC4250@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901192239.25071.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCing ACPI and IDE).

On Sunday 11 January 2009, Lukas Hejtmanek wrote:
> Hello,
> 
> I encountered another problem with the OCZ SSD disk. If I suspend to ram while
> running from batteries, my disk disappears. I had no problem with suspends on
> AC power.
> 
> I created a screenshot of dmesg mesages:
> http://www.fi.muni.cz/~xhejtman/IMG_3221.JPG
