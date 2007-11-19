Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbXKSXFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbXKSXFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 18:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbXKSXF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 18:05:28 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:1387 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbXKSXF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 18:05:26 -0500
Date: Tue, 20 Nov 2007 00:05:24 +0100
From: Olivier Galibert <galibert@pobox.com>
To: "Hack inc." <linux-kernel@vger.kernel.org>
Subject: The /proc/acpi/video/*/DOS default change broke my system
Message-ID: <20071119230524.GA96913@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	"Hack inc." <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

T'was done as a21101c46ca5b4320e31408853cdcbf7cb1ce4ed.  The system is
a latitude x300 (i855GM).  With '1', the old default, I can close and
re-open the lid and have nothing happening.  With '0' the screen turns
black with the mouse cursor left frozen on top of it and the computer
crashed.

Closing the lid also raises a "video bus notify".

How can I go about debugging that?

  OG.

