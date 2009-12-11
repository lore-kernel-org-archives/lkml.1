Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbZLKJ2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbZLKJ2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 04:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbZLKJ2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:28:12 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:39286 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZLKJ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:28:10 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device mapper warnings
Date: Fri, 11 Dec 2009 10:28:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-release; KDE/4.3.2; i686; ; )
Cc: Mike Snitzer <snitzer@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
References: <200912091049.12604.borntraeger@de.ibm.com> <170fa0d20912091656s31575d0cneaf899e1781bdc16@mail.gmail.com> <yq1bpi7vdes.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1bpi7vdes.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912111028.05512.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 10 Dezember 2009 02:14:03 schrieb Martin K. Petersen:
> The warning is caused by an error in stacking discard granularity.  I
> have a fix but I'd like to run verify all my oddball alignment combos
> before submitting.

Martin,

any news on the final fix? Do you want Heinz and me to verify your fix
on our systems?

Christian
