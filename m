Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbZHZWuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbZHZWuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 18:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZHZWuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 18:50:17 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:36576 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbZHZWuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 18:50:17 -0400
Date: Thu, 27 Aug 2009 00:50:18 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Subject: Re: ksoftirqd/0 using 100% of CPU0 (Intel Atom N270, 2.6.30 kernel)
Message-ID: <20090826225018.GA15586@hardeman.nu>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20090826223415.GA27242@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090826223415.GA27242@hardeman.nu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 12:34:15AM +0200, David Härdeman wrote:
> I recently bought a QNAP TS-439 Pro Turbo NAS which uses an Intel Atom  
> N270 processor. Hardware specs are here:
> http://www.qnap.com/pro_detail_hardware.asp?p_id=110
>
> Installed Debian Lenny with a backported 2.6.30 kernel. The problem is  
> that ksoftirq/0 takes up 100% of CPU core 0 as shown by top:

Nevermind, problem went away by updating to latest 2.6.30.x kernel using 
Debian backports :)

-- 
David Härdeman
