Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbXIWWe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbXIWWe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 18:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbXIWWeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 18:34:18 -0400
Received: from marcansoft.com ([80.68.93.119]:2282 "EHLO smtp.marcansoft.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbXIWWeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 18:34:17 -0400
Message-ID: <46F6E9E5.2080809@marcansoft.com>
Date: Sun, 23 Sep 2007 18:34:13 -0400
From: Hector Martin <hector@marcansoft.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070821)
MIME-Version: 1.0
To: Diego Calleja <diegocg@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Coding FATX support for 2.6
References: <46F6D1C3.2070208@marcansoft.com> <20070924002513.f11d1546.diegocg@gmail.com>
In-Reply-To: <20070924002513.f11d1546.diegocg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Calleja wrote:
> FUSE could be an acceptable solution.

Not really. Booting Xbox-Linux from an image file on a FATX partition is
common. I don't think FUSE would work very well there.


-- 
Hector Martin (hector@marcansoft.com)
Public Key: http://www.marcansoft.com/marcan.asc

