Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZLDAtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZLDAtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:49:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZLDAtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:49:06 -0500
Received: from perceval.irobotique.be ([92.243.18.41]:48449 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbZLDAtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:49:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Daniel Ritz <daniel.ritz@gmx.ch>
Subject: Re: [PATCH] uvcvideo: add another YUYV format GUID
Date: Thu, 3 Dec 2009 21:15:30 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.6; KDE/4.3.4; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch
References: <1259711324.13720.20.camel@MacRitz2>
In-Reply-To: <1259711324.13720.20.camel@MacRitz2>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912032115.30431.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Wednesday 02 December 2009 00:48:44 Daniel Ritz wrote:
> For some unknown reason, on a MacBookPro5,3 the iSight

Could you please send me the output of lsusb -v both with the correct and 
wrong GUID ?

> _sometimes_ report a different video format GUID.

Sometimes only ? Now that's weird. Is that completely random ?

> This patch add the other (wrong) GUID to the format table, making the iSight
> work always w/o other problems.
> 
> What it should report: 32595559-0000-0010-8000-00aa00389b71
> What it often reports: 32595559-0000-0010-8000-000000389b71
> 
> Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>

--
Regards,

Laurent Pinchart
