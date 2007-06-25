Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbXFYMTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbXFYMTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbXFYMTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:19:40 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:55986 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXFYMTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:19:39 -0400
Subject: Re: [PATCH]is_power_of_2-ufs/super.c
From: vignesh babu <vignesh.babu@wipro.com>
Reply-To: vignesh.babu@wipro.com
To: Johannes Weiner <hannes-kernel@saeurebad.de>
Cc: daniel.pirkl@email.cz, dushistov@mail.ru,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>
In-Reply-To: <20070625121316.GA19544@saeurebad.de>
References: <1181808559.2474.9.camel@merlin.linuxcoe.com>
	 <20070625121316.GA19544@saeurebad.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: WIPRO Technologies
Date: Mon, 25 Jun 2007 17:51:19 +0530
Message-Id: <1182774079.4339.0.camel@merlin.linuxcoe.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
X-OriginalArrivalTime: 25 Jun 2007 12:20:04.0752 (UTC) FILETIME=[2945B100:01C7B723]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Hannes, Im on it...

On Mon, 2007-06-25 at 14:13 +0200, Johannes Weiner wrote:
> egrep -R '([a-zA-Z0-9_.>]+) *& *\(\1 *- *1\)' /usr/src/linux
-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"

