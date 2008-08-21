Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYHUHnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYHUHnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 03:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbYHUHm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 03:42:57 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:39356 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbYHUHm4 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 03:42:56 -0400
Message-ID: <48AD1C7A.6020705@de.ibm.com>
Date: Thu, 21 Aug 2008 09:42:50 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?BM_Deutschland_Research_=26_Developm?=
 =?ISO-8859-1?Q?ent_GmbH_/_Vorsitzender_des_Aufsichtsrats=3A_?=
 =?ISO-8859-1?Q?Martin_Jetter=2CGesch=E4ftsf=FChrung=3A_Herbert_Kir?=
 =?ISO-8859-1?Q?cher=2CSitz_der_Gesellschaft=3A_B=F6blingen_/_R?=
 =?ISO-8859-1?Q?egistergericht=3A_Amtsgericht_Stuttgart=2C_HRB_24?=
 =?ISO-8859-1?Q?3294?=
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: jaredeh@gmail.com
CC: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 01/10] AXFS: exporting xip_file_fault() for use with AXFS
References: <48AD00D5.5010904@gmail.com>
In-Reply-To: <48AD00D5.5010904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
> We'll need this for AXFS.  The equivalent function in filemap.c is exported.
> 
> Signed-off-by: Jared Hulbert <jaredeh@gmail.com>
> ---
>  include/linux/mm.h |    4 ++++
>  mm/filemap_xip.c   |    3 ++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
Acked-by: Carsten Otte <cotte@de.ibm.com>
