Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbYGFOip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbYGFOip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 10:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbYGFOig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 10:38:36 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:61535 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817AbYGFOif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 10:38:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=NEdUHU08fFTpaJGGIaH/QxhSgyQqNIx9XHteCxOOSynU89BDELPZKwrXUsvL2O1O66
         W8aJzMjpjf1h42fyLpzyyp3EpGMgnnEqhks6HMavFRWb9kQegnkEnlSTUlekv9wAoH66
         ovHZrZmmNJk1iq08Q84xfk2eocjVIjZFPtf5U=
Message-ID: <4870D8C7.6080100@gmail.com>
Date: Sun, 06 Jul 2008 23:37:59 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: jeff@garzik.org, linux-ide@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, bharrosh@panasas.com,
       greg.freemyer@gmail.com, linux-scsi@vger.kernel.org,
       brking@linux.vnet.ibm.com, liml@rtr.ca, jens.axboe@oracle.com,
       viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org, device@lanana.org
Subject: Re: [PATCHSET 2.6.26-rc8] block: implement extended devt
References: <1215073986-4709-1-git-send-email-tj@kernel.org>
In-Reply-To: <1215073986-4709-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, all.
> 
> This patchset implements extended devt for block devices.  This is
> mainly to work around sd limitations (16 minors per device) but can
> easily be used to allow more partitions or more devices.

I'm updating the patchset.  Please standby a bit.

Thanks.

-- 
tejun
