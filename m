Return-Path: <linux-kernel-owner+w=401wt.eu-S1762329AbYGBHsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762329AbYGBHsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYGBHsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:48:22 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:39109 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754329AbYGBHsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:48:21 -0400
Subject: Re: [PATCH 001/002] linux-input:  bcm5974-0.31: fixed resource
	leak, removed work struct, device data struct introduced
From: Henrik Rydberg <rydberg@euromail.se>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       dmitry.torokhov@gmail.com, robfitz@273k.net, jikos@jikos.cz,
       vojtech@suse.cz, dmonakhov@openvz.org, linux-usb@vger.kernel.org
In-Reply-To: <20080701155925.a4c00a8e.akpm@linux-foundation.org>
References: <1214653629.10495.11.camel@alnilam>
	 <20080701155925.a4c00a8e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 09:46:39 +0200
Message-Id: <1214984799.11086.6.camel@alnilam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.38.185
X-Scan-Result: No virus found in message 1KDx4d-0004pT-9e.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KDx4d-0004pT-9e f12ed308676232a80b4d0b71ea4bdd1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-01 at 15:59 -0700, Andrew Morton wrote:
> > Subject: [PATCH 001/002] linux-input:  bcm5974-0.31: fixed resource leak, removed work struct, device data struct introduced
> 
> hm, I wonder where [002/002] went.

Thank you very much for your comments, I will return shortly with a new
version. I did not fully grasp, from reading
Documentation/SubmitPatches, how the numbering in the subject should
work; when I submit my new version in reply to your mail, should I
submit a complete patch against the vanilla kernel, with number 001/003?

Best Regards,
Henrik Rydberg


