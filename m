Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbYLYJzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbYLYJzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 04:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYLYJzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 04:55:37 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:55280 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYLYJzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 04:55:36 -0500
Date: Thu, 25 Dec 2008 10:55:34 +0100
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: linux ext3 partition hosed, is this hardware of software error?
Message-ID: <20081225095534.GY12914@gamma.logic.tuwien.ac.at>
References: <20081221143640.GF1509@gamma.logic.tuwien.ac.at> <20081221144913.76ca53d3@lxorguk.ukuu.org.uk> <20081221150302.GA3457@gamma.logic.tuwien.ac.at> <20081221155720.36b700f7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081221155720.36b700f7@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On So, 21 Dez 2008, Alan Cox wrote:
> ddrescue should do the trick - anything which will copy all the valid
> sectors and write out the lost ones as zero or similar preserving what is
> left of the file.

Again thanks for your help. I rescued most of the hard disc, fsck
succeeded in finding another superblock by itself, and AFAIS (still
checking) all the stuff is still there.

The only thing I hate is the reinstallation procedure (many system files
are hosed, inconsistent md5sums, ...) and that they will carry away my
laptop for quite a lot of days (still under warranty, 2.5months!)

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
ARDSCULL (n.)
Excuse made by rural Welsh hairdresser for deep wounds inflicted on
your scalp in an attempt to rectify whatever it was that induced the
ardscalpsie (q.v.).
			--- Douglas Adams, The Meaning of Liff
