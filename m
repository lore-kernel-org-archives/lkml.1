Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbZGHWxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbZGHWxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbZGHWxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:53:31 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:22372 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbZGHWxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:53:30 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tarkan Erimer <tarkan.erimer@turknet.net.tr>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4A4CB4B4.5010307@turknet.net.tr>
	<20090702130728.22af524c.akpm@linux-foundation.org>
	<8db1092f0907080609w60e37ac0id49a44bd4796b425@mail.gmail.com>
	<1247063244.4159.40.camel@mulgrave.site>
Date: Wed, 08 Jul 2009 18:52:55 -0400
In-Reply-To: <1247063244.4159.40.camel@mulgrave.site> (James Bottomley's
	message of "Wed, 08 Jul 2009 09:27:24 -0500")
Message-ID: <yq1my7eg52w.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A55234A.00E5:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> You might also try this patch from martin petersen: it will print
James> out the actual command that's causing the problems ... that might
James> give a clue.

Any particular reason you didn't merge that patch, btw.?  It's been
extremely useful on this end...

-- 
Martin K. Petersen	Oracle Linux Engineering

