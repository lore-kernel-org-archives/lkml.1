Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbXHNMCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbXHNMCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 08:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbXHNMCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 08:02:30 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:53324 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbXHNMC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 08:02:29 -0400
Date: Tue, 14 Aug 2007 14:02:26 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: sata_nv + ADMA + Samsung disk problem
Message-ID: <20070814120226.GO19429@boogie.lpds.sztaki.hu>
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu> <46C17634.2040504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C17634.2040504@gmail.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 06:30:28PM +0900, Tejun Heo wrote:

> Hmmm... That's timeout on cache flush, indicative of failing disk.
> Please post the result of 'smartctl -a /dev/sdc'.

Will do when I get home. Note however that this only occurs in ADMA
mode. It never occured with 2.6.20 and it never occured with 2.6.22 ever
since I have disabled ADMA.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
