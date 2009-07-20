Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbZGTMPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbZGTMPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZGTMPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:15:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbZGTMPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:15:12 -0400
Message-ID: <4A645FCE.5030506@suse.de>
Date: Mon, 20 Jul 2009 14:15:10 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: rohan a <info1686@gmail.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: SCSI command (SP-OUT) failing on SLES 9 32-bit
References: <7a7c22420907142137o4253dfb5gcd72176cd6a38beb@mail.gmail.com>	 <7a7c22420907142326t3b8d4f5fqaf3813cb456186ec@mail.gmail.com>	 <7a7c22420907150803v4f4ae9dn9eff41b5d5a7edf6@mail.gmail.com> <1247670563.4236.16.camel@mulgrave.site>
In-Reply-To: <1247670563.4236.16.camel@mulgrave.site>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-07-15 at 20:33 +0530, rohan a wrote:
>> Hi guys,
>>
>> Any suggestions...please help
> 
> I know of no kernel bug that could be causing this.  The SLES9 kernel is
> just too old though for me to remember clearly.  I'd suggest you file a
> support incident with SUSE ... they'll debug and fix this on the older
> kernels; we really only deal with the new kernel and one or two back
> revisions here on linux-scsi.
> 
You did that on purpose.
The 'they' is actually me :-(

Actually, there already _is_ a bug, so no need to open another one.
Which HBA are you using?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
