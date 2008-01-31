Return-Path: <linux-kernel-owner+w=401wt.eu-S1765601AbYAaLtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765601AbYAaLtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 06:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYAaLs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 06:48:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54245
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751743AbYAaLs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 06:48:57 -0500
Date: Thu, 31 Jan 2008 03:49:18 -0800 (PST)
Message-Id: <20080131.034918.135595049.davem@davemloft.net>
To: den@sw.ru
Cc: bunk@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       devel@openvz.org, xemul@openvz.org
Subject: Re: [PATCH 0/3] [RAW]: proc output cleanups.
From: David Miller <davem@davemloft.net>
In-Reply-To: <47A1B1E4.2010804@sw.ru>
References: <47A1B1E4.2010804@sw.ru>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Denis V. Lunev" <den@sw.ru>
Date: Thu, 31 Jan 2008 14:32:52 +0300

> yesterday Adrian Bunk noticed, that the commit
> 
> commit 42a73808ed4f30b739eb52bcbb33a02fe62ceef5
> Author: Pavel Emelyanov <xemul@openvz.org>
> Date:   Mon Nov 19 22:38:33 2007 -0800
> 
> is somewhat strange. Basically, the commit is obviously wrong as the
> content of the /proc/net/raw6 is incorrect due to it.
> 
> This series of patches fixes original problem and slightly cleanups the
> code around.
> 
> Signed-off-by: Denis V. Lunev <den@openvz.org>

All applied, thanks a lot!
