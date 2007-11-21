Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbXKUTde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbXKUTde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 14:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXKUTd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 14:33:26 -0500
Received: from mx4.access-company.com ([12.7.175.32]:54767 "EHLO
	mx3.access-company.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752663AbXKUTdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 14:33:25 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2 ] Add support LZO in mkcramfs tool
Date: Wed, 21 Nov 2007 11:32:03 -0800
Message-ID: <6F917B35767E8F468DE04F5A6EA90D89040108@ussunex02.svl.access-company.com>
In-Reply-To: <20071120011221.GK11527@petra.dvoda.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2 ] Add support LZO in mkcramfs tool
Thread-Index: AcgrEmhbf6CUXkYySlqvZGAO8jJd5ABYqqlQ
References: <1193441160.17726.18.camel@vince-desktop> <20071120011221.GK11527@petra.dvoda.cz>
From: "Vince Kim" <Vince.Kim@access-company.com>
To: "Karel Zak" <kzak@redhat.com>
Cc: <linux-kernel@vger.kernel.org>, "Richard Purdie" <rpurdie@openedhand.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=4.65.5502:2.3.11,1.2.37,4.0.164 definitions=2007-11-21_09:2007-11-19,2007-11-21,2007-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx engine=3.1.0-0708230000 definitions=main-0711210116
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the comment.

I will look through it.

Vince

-----Original Message-----
From: Karel Zak [mailto:kzak@redhat.com] 
Sent: Monday, November 19, 2007 5:12 PM
To: Vince Kim
Cc: linux-kernel@vger.kernel.org; "Richard Purdie
[rpurdie"@openedhand.com
Subject: Re: [PATCH 2/2 ] Add support LZO in mkcramfs tool

On Fri, Oct 26, 2007 at 04:26:00PM -0700, vince kim wrote:
> This patch adds support LZO compression in mkcramfs tool, so it can
> generate a cramfs image compress with LZO.
> To compile mkcramfs with this patch, liblzo2-dev package must be
> installed.
> 
> The patch is created against mkcramfs tool ver 1.1 which can be found
> at:
> http://sourceforge.net/projects/cramfs/

 Ah...

    Latest     1.1 Notes (2002-02-24 00:00)

 ...seems like a zombie project.


 I think many Linux distributions use mkfs.cramfs from
 util-linux[-ng].

 git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
