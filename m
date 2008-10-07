Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYJGSgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYJGSgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYJGSgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:36:15 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:58178 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYJGSgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type
         :content-transfer-encoding:from;
        b=Quv2Mn60eqCanJypU2wJjI14XTN9EhSvLvVmd7/6FTOAu4bzkcS2m9XnHniJsIFIBC
         lSkwOvTV0txdu7ZuV9G4SRm8C4sl/vGhPqJQ7VPqKrprnQ8MwhEZ8foVvBaIkzpBrIuS
         XwDQEawt8DJ1iHnrDj5U1ZwmuSc4lcxbtI+lc=
Message-ID: <48EBAC11.7060803@gmail.com>
Date: Tue, 07 Oct 2008 19:36:01 +0100
User-Agent: Thunderbird 2.0.0.16 (X11/20080810)
MIME-Version: 1.0
To: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: linux-firmware patches
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Dave <kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should patches to add firmware to the linux-firmware tree (and not the main kernel) be sent to linux-kernel, or somewhere else? It wasn't mentioned in the [ANNOUNCE]*, and I haven't been able to find an example on list.

Just wanted to check before posting an 80k patch consisting of non-GPL binary files.


Thanks,

Dave.

* <http://lkml.org/lkml/2008/8/15/241>
