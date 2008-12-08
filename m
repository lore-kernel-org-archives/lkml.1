Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYLHQcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYLHQcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 11:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYLHQcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 11:32:39 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:57128 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbYLHQci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 11:32:38 -0500
Message-ID: <493D4C1B.4030006@s5r6.in-berlin.de>
Date: Mon, 08 Dec 2008 17:32:27 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.17) Gecko/20080829 SeaMonkey/1.1.12
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Holger Hoffstaette <holger@wizards.de>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, stable@kernel.org
Subject: Re: Nasty regression from .27.7 to .27.8: idle samba goes crazy
References: <pan.2008.12.08.06.18.57.357875@wizards.de> <200812080834.22924.rjw@sisk.pl>
In-Reply-To: <200812080834.22924.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Please bisect.

Why should he bisect before the developers who added networking related
patches to .8 attempted to reproduce the bug, let alone looked at the
report?

Actually he "bisected" it already to the diff of .7->.8.

(Maybe it is not a networking bug, but that's where it makes most sense
to start to look.)
-- 
Stefan Richter
-=====-==--- ==-- -=---
http://arcgraph.de/sr/
