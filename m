Return-Path: <linux-kernel-owner+w=401wt.eu-S964778AbXCSVRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778AbXCSVRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964960AbXCSVRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:17:44 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:27187 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964778AbXCSVRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:17:43 -0400
To: "Bryan O'Sullivan" <bos@pathscale.com>
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00 of 33] Set of ipath patches for 2.6.22
X-Message-Flag: Warning: May contain useful information
References: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 19 Mar 2007 14:17:30 -0700
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com> (Bryan O'Sullivan's message of "Thu, 15 Mar 2007 14:44:44 -0700")
Message-ID: <adavegxlyqd.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Mar 2007 21:17:30.0479 (UTC) FILETIME=[00BDA7F0:01C76A6C]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Are these really all for 2.6.22?  Some of them seem like bugfixes that
you would want in 2.6.21...
