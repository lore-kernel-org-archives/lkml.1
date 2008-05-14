Return-Path: <linux-kernel-owner+w=401wt.eu-S1751826AbYENH3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbYENH3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 03:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYENH3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 03:29:03 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:33133 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbYENH3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 03:29:01 -0400
Date: Wed, 14 May 2008 09:28:58 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc2 hosed X?
Message-ID: <20080514072858.GA9979@gamma.logic.tuwien.ac.at>
References: <20080513103828.GA8288@gamma.logic.tuwien.ac.at> <21d7e9970805140000o2191160eida777023909bf033@mail.gmail.com> <20080514070631.GB10549@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514070631.GB10549@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mi, 14 Mai 2008, Ingo Molnar wrote:
> Here it is below for those who'd like to try that fix as a standalone 
> patch.

I confirm that this patch fixed the problems I had. s2ram, switching to
console worked again.

And now that you mentioned it, there were some lines about vblank bit I
wasn't sure whether they are new or not.

Thanks a lot 

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
LULWORTH (n.)
Measure of conversation. A lulworth defines the amount of the length,
loudness and embarrassment of a statement you make when everyone else
in the room unaccountably stops talking at the same time.
			--- Douglas Adams, The Meaning of Liff
