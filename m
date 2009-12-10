Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbZLJOIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbZLJOIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758514AbZLJOIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:08:39 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbZLJOIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:08:38 -0500
Date: Thu, 10 Dec 2009 15:08:42 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device
 mapper warnings
Message-ID: <20091210140842.GA6168@fancy-poultry.org>
References: <200912091049.12604.borntraeger@de.ibm.com>
 <20091209214501.GC8742@kernel.dk>
 <20091209220749.GD8742@kernel.dk>
 <200912101208.26510.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912101208.26510.borntraeger@de.ibm.com>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0x3FAF957D
X-OpenPGP-Fingerprint: 0BAE BB83 8B8A 3DE4 08F3  CEB9 DA0F CCBB 3FAF 957D
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20091108 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX18zk5EirQl08HgMYz8V/aKLz5/7mbW1l6U2HoM
 3Dszy3mrHB6F7vd94IXlQ4HGfhnUbgQRv1JUvNBq52It+rLLgX
 55Jd+hEDzX2ehnRlfL17Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.12.2009, Christian Borntraeger wrote: 

> Yes it does. 

Yes, that fixes it for me too.

Thanks,
Heinz.
