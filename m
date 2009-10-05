Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbZJEIdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbZJEIdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758558AbZJEIdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:33:50 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:34479 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516AbZJEIdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:33:50 -0400
Date: Mon, 5 Oct 2009 17:33:08 +0900
To: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: complete IO hang since a few kernel revision
Message-ID: <20091005083308.GB5612@gandalf.dynalias.org>
References: <20091005011626.GH4335@gamma.logic.tuwien.ac.at>
 <4AC9607D.6050900@datenparkplatz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC9607D.6050900@datenparkplatz.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Oct 2009, Ulrich Lukas wrote:
> A number of patches went into 2.6.32-rc3 which was released today.

Ok, with 2.6.32-rc3 running now.

> Can you test if your problems are solved with this latest version?

Example:
dpkg-source -x of a big debian source package
which is more or less untarring a big .tar and then applying a diff
which is much smaller (tar.gz: 482M, diff.gz: 412k)

The dpkg-source has finished, I am back at the prompt.

At the same time a simple
	$ <ENTER>
in a different xterm did not produce *any* thing, no output, for about
30 seconds. I mean 30 seconds waiting for an empty command is a bit
strange I would say.

I don't know to which this is related, but it seems quite buggy.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining                                        Associate Professor
JAIST Japan Advanced Institute of Science and Technology   preining@jaist.ac.jp
Vienna University of Technology                               preining@logic.at
Debian Developer (Debian TeX Task Force)                    preining@debian.org
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
CLABBY (adj.)
A 'clabby' conversation is one stuck up by a commissionaire or
cleaning lady in order to avoid any further actual work. The opening
gambit is usually designed to provoke the maximum confusion, and
therefore the longest possible clabby conversation. It is vitally
important to learn the correct, or 'clixby' (q.v.), responses to a
clabby gambit, and not to get trapped by a 'ditherington' (q.v.). For
instance, if confronted with a clabby gambit such as 'Oh, mr Smith, I
didn't know you'd had your leg off', the ditherington response is 'I
haven't....' whereas the clixby is 'good.'
			--- Douglas Adams, The Meaning of Liff
