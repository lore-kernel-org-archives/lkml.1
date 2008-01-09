Return-Path: <linux-kernel-owner+w=401wt.eu-S1751681AbYAIFSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbYAIFSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 00:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbYAIFSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 00:18:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:53777 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYAIFS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 00:18:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rF1XQlVTHajDdpksYNmnHQwnZTwoNCKG2020SY1sJz4X0uqGZtsJt83vbY9UsuTjALDe+DsHWdYFQIg2P7NkuZs/JM1dYht71WhIonezOBnboFViAqa0yPN+/k8dONPWlef5zuUB64ARc1UYzdyVW+nLq9cYQU3NkS4V40u8G4Y=
Message-ID: <4784591D.3060000@gmail.com>
Date: Wed, 09 Jan 2008 14:18:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Mark Lord <liml@rtr.ca>
Subject: Re: Do SATA tape drives work?
References: <200801090329.m093T7Op019488@turbo.physics.adelaide.edu.au>
In-Reply-To: <200801090329.m093T7Op019488@turbo.physics.adelaide.edu.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing linux-ide]

Jonathan Woithe wrote:
> Hi guys
> 
> I was wondering whether anyone can shed any light on the status of SATA tape
> drives.  There's very little info on the net about this at least in the
> places I've checked; the only thing of any significance I've found thus far
> is a note in a Bacula document dated April 2007 which states that drives
> other than real SCSI units don't generally work with Bacula.
> 
> To put this into context, I'm looking at purchasing a Sony SDX470VRB SATA
> AIT-1 tape drive for use with the SATA controller on an Intel DG31PR
> mainboard.  The drive will be used primarily with tar/cpio.  Obvsiouly
> however I only want to make the purchase if there's a reasonable chance of
> it working.
> 
> I would appreciate any information you can shed on this issue.

It's supposed to with recent updates.  Mark, right?

-- 
tejun
