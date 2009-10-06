Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZJFHQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZJFHQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbZJFHQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:16:51 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:34172 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbZJFHQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:16:51 -0400
Date: Tue, 6 Oct 2009 16:16:09 +0900
To: Mike Galbraith <efault@gmx.de>
Cc: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org
Subject: Re: complete IO hang since a few kernel revision
Message-ID: <20091006071609.GB21772@gandalf.dynalias.org>
References: <20091005011626.GH4335@gamma.logic.tuwien.ac.at>
 <4AC9607D.6050900@datenparkplatz.de>
 <20091005083308.GB5612@gandalf.dynalias.org>
 <1254813111.6293.22.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254813111.6293.22.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Oct 2009, Mike Galbraith wrote:
> I've tried unsuccessfully to reproduce this behavior.
> 
> Since it doesn't appear to be something readily reproducible, more
> information and/or some digging on your part may be needed.

Hm, how could I do that? I am fine with compiling some strange 
kernel options, or running some debugging task, but I don't have
and netconsole or serial console available.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining                                        Associate Professor
JAIST Japan Advanced Institute of Science and Technology   preining@jaist.ac.jp
Vienna University of Technology                               preining@logic.at
Debian Developer (Debian TeX Task Force)                    preining@debian.org
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
MEATHOP (n.)
One who sets off for the scene of an aircraft crash with a picnic
hamper.
			--- Douglas Adams, The Meaning of Liff
