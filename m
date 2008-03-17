Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbYCQUXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbYCQUXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYCQUXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:23:09 -0400
Received: from hs-out-0708.google.com ([64.233.178.240]:54295 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbYCQUXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:23:08 -0400
Message-ID: <fa686aa40803171323r2e73e53xd01d0590efccbf90@mail.gmail.com>
Date: Mon, 17 Mar 2008 14:23:02 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
Subject: Re: [PATCH 1/3] Xilinx: hwicap: Refactor status handling code.
Cc: git-dev@xilinx.com, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080317173644.C24651C00069@mail59-sin.bigfish.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1205775392-32222-1-git-send-email-stephen.neuendorffer@xilinx.com>
	 <20080317173644.C24651C00069@mail59-sin.bigfish.com>
X-Google-Sender-Auth: 5ea467629f7b3ac4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 11:36 AM, Stephen Neuendorffer
<stephen.neuendorffer@xilinx.com> wrote:
> Both the buffer-based and fifo-based icap cores have a status
>  register.  Previously, this was only used internally to check whether
>  transactions have completed.  However, the status can be useful to the
>  main driver as well.  This patch exposes these status functions to the
>  main driver along with some masks for the differnet bits.
>
>  Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
