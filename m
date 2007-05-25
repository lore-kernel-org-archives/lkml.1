Return-Path: <linux-kernel-owner+w=401wt.eu-S1764585AbXEYReR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764585AbXEYReR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763177AbXEYReE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:34:04 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:38546 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763168AbXEYReD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:34:03 -0400
Message-ID: <46571E08.1050509@s5r6.in-berlin.de>
Date: Fri, 25 May 2007 19:34:00 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Auke Kok <auke-jan.h.kok@intel.com>
CC: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [condingstyle] Add chapter on tests
References: <20070525172509.5138.56430.stgit@localhost.localdomain> <20070525172515.5138.13652.stgit@localhost.localdomain>
In-Reply-To: <20070525172515.5138.13652.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Auke Kok wrote:
> +If you give your variables and pointers good names, there is never a need
> +to compare the value stored in that variable to NULL or true/false, so
> +omit all that and keep it short.

I agree with this in principle.  But do we have to standardize it?
-- 
Stefan Richter
-=====-=-=== -=-= ==--=
http://arcgraph.de/sr/
