Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYDCWsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYDCWsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 18:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbYDCWsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 18:48:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47130 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYDCWsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 18:48:36 -0400
Message-ID: <47F55EA7.1090406@zytor.com>
Date: Thu, 03 Apr 2008 15:48:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: MPSC should use P6 NOPs
References: <Pine.LNX.4.64.0804032344260.28157@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0804032344260.28157@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> I've now noticed that the machine I call MPENTIUM4 for 32-bit kernels
> is called MPSC for 64-bit kernels, and in that case it still doesn't
> get the P6 NOPs it ought to.  hpa explains that MK8 should still be
> excluded, so it's just a matter of including MPSC along with MPENTIUM4.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Acked-by: H. Peter Anvin <hpa@zytor.com>
