Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYGDCqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYGDCqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 22:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbYGDCqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 22:46:25 -0400
Received: from demeter.kernel.org ([140.211.167.37]:46102 "EHLO
	hera.kernel.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754883AbYGDCqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 22:46:24 -0400
X-Greylist: delayed 4948 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 22:46:24 EDT
Message-ID: <486CF646.9090208@kernel.org>
Date: Fri, 04 Jul 2008 00:54:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: jeff@garzik.org, linux-ide@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, bharrosh@panasas.com,
       greg.freemyer@gmail.com, linux-scsi@vger.kernel.org,
       brking@linux.vnet.ibm.com, liml@rtr.ca, jens.axboe@oracle.com,
       viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org, device@lanana.org
Subject: Re: [PATCHSET 2.6.26-rc8] block: implement extended devt
References: <1215073986-4709-1-git-send-email-tj@kernel.org> <20080703132821.GE14894@parisc-linux.org>
In-Reply-To: <20080703132821.GE14894@parisc-linux.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jul 03, 2008 at 05:33:00PM +0900, Tejun Heo wrote:
>> I chose major 259 at my own whim.  Is it okay to use this value?  As
> 
> No.  You need to get it assigned by LANANA (Torben Mathiasen
> <device@lanana.org>).  See Documentation/devices.txt.

Yeap, already cc'd && the question was sorta directed to LANANA.  :-)

-- 
tejun
