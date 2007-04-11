Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbXDKQyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbXDKQyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 12:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbXDKQyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 12:54:07 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:43886 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbXDKQyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 12:54:06 -0400
Message-ID: <461D1291.2060703@s5r6.in-berlin.de>
Date: Wed, 11 Apr 2007 18:53:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/30] Use menuconfig objects
References: <200704110112.39425.a1426z@gawab.com> <Pine.LNX.4.61.0704110026250.32056@yvahk01.tjqt.qr> <200704110742.38727.a1426z@gawab.com> <Pine.LNX.4.61.0704110937060.32056@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704110937060.32056@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Apr 11 2007 07:42, Al Boldi wrote:
>>Also, I don't think it's necessary to touch any of the "depends on"; keep 
>>them as is, as they don't hurt staying that way, and may actually be 
>>necessary under certain circumstances.  (see EMBEDDED)
> 
> Simplifying the depends lines is a good thing IMO.

If explicit dependency statements are replaced by if--endif blocks, does
this count as simplification?
-- 
Stefan Richter
-=====-=-=== -=-- -=-==
http://arcgraph.de/sr/
