Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbYBYS3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbYBYS3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbYBYS3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:29:45 -0500
Received: from server54.tchmachines.com ([72.9.244.106]:50828 "EHLO
	server54.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYBYS3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:29:44 -0500
Date: Mon, 25 Feb 2008 10:29:37 -0800
From: Ravikiran Thirumalai <kiran@scalemp.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, robert@schwebel.de,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       "Martin J. Bligh" <mbligh@aracnet.com>, pazke@donpac.ru,
       florian.fainelli@telecomint.eu, Shai Fultheim <shai@scalemp.com>,
       linux-kernel@vger.kernel.org, linux-visws-devel@lists.sourceforge.net
Subject: Re: defconfig's for all x86 subarchitectures
Message-ID: <20080225182937.GD3143@localdomain>
References: <20080224201634.GD1596@cs181133002.pp.htv.fi> <20080224204039.GA11894@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224204039.GA11894@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server54.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 09:40:39PM +0100, Sam Ravnborg wrote:
>On Sun, Feb 24, 2008 at 10:16:34PM +0200, Adrian Bunk wrote:
>> For compile tests it would be nice it we had at least for each 
>> subarchitecture not covered by X86_GENERICARCH a defconfig.
>> 
>> These are the following subarchitectures:
>> - X86_ELAN
>> - X86_VOYAGER
>> - X86_NUMAQ
>> - X86_VISWS
>> - X86_RDC321X
>> - X86_VSMP
>
>Seconded!
>

Thirded :).  A very good idea indeed.  Will post a X86_VSMP defconfig soon.

Thanks,
Kiran
