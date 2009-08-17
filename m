Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbZHQJkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbZHQJkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbZHQJkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:40:10 -0400
Received: from welcomes-you.com ([85.214.50.128]:52555 "EHLO
	smtp.welcomes-you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbZHQJkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:40:08 -0400
X-Greylist: delayed 2049 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Aug 2009 05:40:08 EDT
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Organization: Max Planck Institute for Gravitational Physics
To: linux-kernel@vger.kernel.org
Subject: Backporting newer EDAC drivers to "stable" tree 2.6.27.x?
Date: Mon, 17 Aug 2009 11:06:00 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-1-686; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908171106.00973.carsten.aulbert@aei.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

what is the recommended way to incorporate newer EDAC drivers from 2.6.30 or 
later into the long term 2.6.27.x series? Are there ongoing efforts already we 
could just re-use or does one "just" take the latest patchset and tries to 
apply it cleanly (enough) to the latest long term kernel?

Thanks a lot for any pointers/help

Cheers

Carsten 
