Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbYDXWht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbYDXWht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbYDXWhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:37:39 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:3702 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbYDXWhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:37:38 -0400
From: James Cloos <cloos@jhcloos.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression: starting X locks box with git master
In-Reply-To: <86802c440804241352v2623222bt28129a2c501cff25@mail.gmail.com>
	(Yinghai Lu's message of "Thu, 24 Apr 2008 13:52:53 -0700")
References: <m3hcdrqb03.fsf@lugabout.jhcloos.org>
	<86802c440804241352v2623222bt28129a2c501cff25@mail.gmail.com>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/23.0.60 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2007 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
X-Hashcash: 1:23:080424:yhlu.kernel@gmail.com::oawBgn0za2eDNjPb:0000000000000000000000000000000000000000Hf8Q
X-Hashcash: 1:23:080424:linux-kernel@vger.kernel.org::Zf7+uIIEQrMqeztY:000000000000000000000000000000000sm6R
Date: Thu, 24 Apr 2008 18:36:54 -0400
Message-ID: <m37iemq3qa.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Yinghai" == Yinghai Lu <yhlu.kernel@gmail.com> writes:

Yinghai> Do you have CONFIG_X86_PAT in your .config?

I do not find that in .config at all, set or not:

:; grep X86_PAT /usr/src/linux-2.6/.config

returns nothing.

But the kernel which dies does generate this:

Apr 24 04:28:09 [kernel] [    0.000000] x86: PAT support disabled.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
