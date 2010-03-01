Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab0CAV0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:26:21 -0500
Received: from ozlabs.org ([203.10.76.45]:53359 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab0CAV0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:26:20 -0500
Date: Tue, 2 Mar 2010 08:26:16 +1100
From: Paul Mackerras <paulus@samba.org>
To: Luca Barbieri <luca@luca-barbieri.com>
Cc: hpa@zytor.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] lib: fix atomic64_add_unless return value
 convention
Message-ID: <20100301212616.GI26848@brick.ozlabs.ibm.com>
References: <1267463700-25524-1-git-send-email-luca@luca-barbieri.com>
 <1267463700-25524-4-git-send-email-luca@luca-barbieri.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267463700-25524-4-git-send-email-luca@luca-barbieri.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 06:15:00PM +0100, Luca Barbieri wrote:
> The 0 and 1 return values were incorrectly swapped.
> 
> Reported-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>

Acked-by: Paul Mackerras <paulus@samba.org>
