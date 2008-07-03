Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbYGCN2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbYGCN2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYGCN2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:28:25 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58294 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYGCN2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:28:23 -0400
Date: Thu, 3 Jul 2008 07:28:21 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, bharrosh@panasas.com,
       greg.freemyer@gmail.com, linux-scsi@vger.kernel.org,
       brking@linux.vnet.ibm.com, liml@rtr.ca, jens.axboe@oracle.com,
       viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org, device@lanana.org
Subject: Re: [PATCHSET 2.6.26-rc8] block: implement extended devt
Message-ID: <20080703132821.GE14894@parisc-linux.org>
References: <1215073986-4709-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215073986-4709-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 05:33:00PM +0900, Tejun Heo wrote:
> I chose major 259 at my own whim.  Is it okay to use this value?  As

No.  You need to get it assigned by LANANA (Torben Mathiasen
<device@lanana.org>).  See Documentation/devices.txt.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
