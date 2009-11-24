Return-Path: <linux-kernel-owner+w=401wt.eu-S933197AbZKXO4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197AbZKXO4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933126AbZKXO4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:56:53 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44052 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933124AbZKXO4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:56:52 -0500
Date: Tue, 24 Nov 2009 14:58:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: The -next kernel no longer boots on kvm in 32bit mode
Message-ID: <20091124145855.2b73892e@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


64bit Intel host system
Fedora host environment

32bit guest built with CPU i686 and no PAE support

This now momentarily flickers up something then reboots back to the BIOS.

