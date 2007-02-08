Return-Path: <linux-kernel-owner+w=401wt.eu-S1422845AbXBHHVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422845AbXBHHVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 02:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030670AbXBHHVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 02:21:33 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:37851 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030668AbXBHHVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 02:21:32 -0500
In-Reply-To: <yq17iut7b51.fsf@sermon.lab.mkp.net>
To: martin.petersen@oracle.com, cebbert@redhat.com,
       james.bottomley@steeleye.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, randy.dunlap@oracle.com
MIME-Version: 1.0
Subject: Re: [patch] Re: SCSI logging sucks
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Volker Sameske <SAMESKE@de.ibm.com>
X-MIMETrack: S/MIME Sign by Notes Client on Volker Sameske/Germany/IBM(Release 7.0 HF277|June
 21, 2006) at 08.02.2007 08:20:16,
	Serialize by Notes Client on Volker Sameske/Germany/IBM(Release 7.0 HF277|June
 21, 2006) at 08.02.2007 08:20:16,
	Serialize complete at 08.02.2007 08:20:16,
	S/MIME Sign failed at 08.02.2007 08:20:16: The cryptographic key was not
 found,
	Serialize by Router on D12ML067/12/M/IBM(Release 6.5.5HF882 | September 26, 2006) at
 08/02/2007 08:21:28,
	Serialize complete at 08/02/2007 08:21:28
Message-ID: <OF1C4B234E.A190DBFA-ONC125727C.0027B4A0-C125727C.002852B5@de.ibm.com>
Date: Thu, 8 Feb 2007 08:21:26 +0100
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There's a very convenient script called scsi_logging_level included in
> (of all things) the s390-tools package.
> 
> Maybe provide a pointer to it -- or even just include it.  It's not
> very big...
> 
> 
http://www-128.ibm.com/developerworks/linux/linux390/s390-tools-1.5.4.html

The scsi_logging_level script is described here in chapter 8:
http://download.boulder.ibm.com/ibmdl/pub/software/dw/linux390/docu/l26cts01.pdf

and here on page 312:
http://download.boulder.ibm.com/ibmdl/pub/software/dw/linux390/docu/l26cdd02.pdf

regards,
Volker
