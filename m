Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbYELPl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbYELPl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 11:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYELPls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 11:41:48 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:63156 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbYELPlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 11:41:47 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Pavel Emelyanov <xemul@openvz.org>, infinipath@qlogic.com,
       ralph.campbell@qlogic.com
Cc: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       John Gregor <john.gregor@qlogic.com>, general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][INFINIBAND]: Make ipath_portdata work with struct pid * not pid_t.
References: <482857AE.2030904@openvz.org>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 12 May 2008 08:41:18 -0700
In-Reply-To: <482857AE.2030904@openvz.org> (Pavel Emelyanov's message of "Mon,
	12 May 2008 18:43:58 +0400")
Message-ID: <adave1jo7hd.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 May 2008 15:41:18.0520 (UTC) FILETIME=[9ECFFB80:01C8B446]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems fine to me... ipath guys, any comment?  I think it would be
reasonale to include this with the other ipath fixes when I ask Linus to
pull in a day or two.
