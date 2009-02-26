Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZBZPd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZBZPd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 10:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZBZPds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 10:33:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45564 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbZBZPdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 10:33:47 -0500
Message-ID: <49A6B604.1060702@zytor.com>
Date: Thu, 26 Feb 2009 07:32:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Matthew Wilcox <matthew@wil.cx>, Theodore Tso <tytso@mit.edu>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>	<20090226025043.GJ1363@mit.edu>	<20090226030735.GA16891@parisc-linux.org> <yq1eixlg4mn.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1eixlg4mn.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin K. Petersen wrote:
> 
> Quick answer from one of my contacts.  Desktop drives will indeed ship
> with an alignment of 1(*).  The alignment is hardwired at time of
> manufacture and can't be changed.
> 

Oh God.

This is a disaster.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

