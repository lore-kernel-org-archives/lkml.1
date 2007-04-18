Return-Path: <linux-kernel-owner+w=401wt.eu-S1422832AbXDRK4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422832AbXDRK4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422833AbXDRK4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:56:15 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:39150 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422832AbXDRK4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:56:15 -0400
Message-ID: <4625F92D.5000807@s5r6.in-berlin.de>
Date: Wed, 18 Apr 2007 12:55:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] include files: convert "include" subdirectory to UTF-8
References: <alpine.DEB.0.83.0704171345510.914@sigma.j-a-k-j.com> <4625E7BD.6070404@s5r6.in-berlin.de>
In-Reply-To: <4625E7BD.6070404@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Aren't we using ASCII for C sources?

Not anymore, according to http://lkml.org/lkml/2007/4/18/94 .
-- 
Stefan Richter
-=====-=-=== -=-- =--=-
http://arcgraph.de/sr/
